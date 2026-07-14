#!/usr/bin/env bash
#
# Back up <src-dir> into <dest-dir>, keeping a rolling series of dated snapshots
# that together occupy at most <max-gb> gigabytes.
#
#   usage: backup-enc.sh <src-dir> <dest-dir> <max-gb> [archive-name]
#
#   e.g.  backup-enc.sh ~/ugh/enc /run/media/jeff/ext_hdd.9g.tshb 15 enc,org-hdd
#         backup-enc.sh ~/ugh/enc ~ 5 enc,org-ssd
#
# [archive-name] defaults to the basename of <src-dir>. It names both the live
# archive and the snapshot folder, so give the copy on each drive its own name
# -- the two above are distinguishable at a glance as the hdd and ssd copies.
# Both land directly in <dest-dir>:
#
#   <dest-dir>/<archive-name>.zip   the current backup
#   <dest-dir>/<archive-name>/      every older backup, one zip per run
#
# Each run:
#   1. Retires the current <archive-name>.zip into the <archive-name>/ folder,
#      renamed for the date it was created. Old backups thus accumulate there
#      as a series of dated snapshots.
#   2. Deletes the oldest snapshots, if needed, until that folder is back down
#      to <max-gb> GiB. The newest snapshot is never deleted.
#   3. Zips <src-dir> from scratch into a new <archive-name>.zip.
#
# Step 1 is what makes step 3 correct: zip ADDS to an existing archive rather
# than replacing it, so zipping on top of an old <archive-name>.zip would
# silently carry its stale contents forward, growing the archive every run.
# Moving the old one out of the way first guarantees each backup starts empty.
#
# NOTE ON THE BUDGET: <max-gb> bounds the <archive-name>/ folder only. The
# live <archive-name>.zip sits outside it, so peak usage on the drive is
# roughly <max-gb> plus one snapshot. Size the number accordingly.
#
set -euo pipefail

usage() {
  local me; me=$(basename "$0")
  echo "usage: $me <src-dir> <dest-dir> <max-gb> [archive-name]" >&2
  echo "  e.g. $me ~/ugh/enc /run/media/jeff/ext_hdd.9g.tshb 15 enc,org-hdd" >&2
  echo "       $me ~/ugh/enc ~ 5 enc,org-ssd" >&2
  exit 1
}
(( $# >= 3 && $# <= 4 )) || usage

MAX_GB="$3"

[[ "$MAX_GB" =~ ^[0-9]+(\.[0-9]+)?$ ]] ||
  { echo "max-gb must be a positive number, got '$MAX_GB'" >&2; exit 1; }
# %.0f, not %d: some awks truncate %d through a 32-bit int, and any budget past
# 2 GiB overflows that. %.0f formats the double directly.
MAX_BYTES=$(awk "BEGIN { printf \"%.0f\", $MAX_GB * 1024 * 1024 * 1024 }")
(( MAX_BYTES > 0 )) || { echo "max-gb must be greater than zero" >&2; exit 1; }

[[ -d "${1%/}" ]] || { echo "Source ${1%/} not found" >&2; exit 1; }
# Deliberately not mkdir -p: a destination that doesn't exist means a typo, or
# a drive that isn't mounted. Creating it would "succeed" at backing up nowhere.
[[ -d "${2%/}" ]] ||
  { echo "Destination ${2%/} not found -- drive not mounted?" >&2; exit 1; }

# Absolute and symlink-free. Step 3 builds the zip from inside $SRC's parent, so
# a relative path would otherwise be resolved against the wrong directory. This
# also strips any trailing slash, which basename/dirname would otherwise trip on.
SRC=$(realpath -- "${1%/}")
DEST_DIR=$(realpath -- "${2%/}")
NAME="${4:-$(basename "$SRC")}"

# The source may live inside the destination -- backing ~/ugh/enc up to ~ is the
# whole point of the ssd copy. The reverse is what breaks: an archive written
# inside the tree being archived would be feeding itself its own bytes.
case "$DEST_DIR/" in
  "$SRC"/*)
    echo "Destination $DEST_DIR is inside source $SRC; the zip would be" \
         "archiving itself." >&2
    exit 1 ;;
esac

ZIP="$DEST_DIR/$NAME.zip"
ARCHIVE_DIR="$DEST_DIR/$NAME"
mkdir -p "$ARCHIVE_DIR"

# Step 1 retires the old archive before step 3 has built a new one, so between
# them there is a window with no <archive-name>.zip on the drive. If step 3
# fails -- a broken symlink, a full disk, a Ctrl-C -- we must put the old one
# back, or the run ends having silently removed the current backup.
retired=""
tmp=""
cleanup() {
  local rc=$?
  if (( rc != 0 )); then
    [[ -n "$tmp" && -e "$tmp" ]] && rm -f -- "$tmp"
    if [[ -n "$retired" && -e "$retired" && ! -e "$ZIP" ]]; then
      echo "Failed; restoring previous archive from $retired" >&2
      mv "$retired" "$ZIP"
    fi
  fi
  exit "$rc"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

# 1. Retire the existing archive, named for when it was created.
if [[ -e "$ZIP" ]]; then
  # %W is birth time, and is 0 or '-' on filesystems that don't record one;
  # fall back to mtime, which for a write-once archive is when zip finished.
  btime=$(stat -c %W "$ZIP")
  if [[ "$btime" =~ ^[0-9]+$ ]] && (( btime > 0 )); then
    stamp=$(date -d "@$btime" +%Y-%m-%d_%H-%M-%S)
  else
    stamp=$(date -r "$ZIP" +%Y-%m-%d_%H-%M-%S)
  fi

  retired="$ARCHIVE_DIR/$stamp.zip"
  n=1
  while [[ -e "$retired" ]]; do
    retired="$ARCHIVE_DIR/$stamp.$n.zip"
    (( n++ ))
  done

  echo "Retiring $(du -h "$ZIP" | cut -f1) archive -> $retired"
  mv "$ZIP" "$retired"
fi

# 2. Delete oldest snapshots until the folder fits in the budget.
#    The newest snapshot is never deleted, even if it alone busts the budget.
#
#    Ordering is by mtime, which mv preserves, so a retired snapshot keeps the
#    time zip finished writing it -- consistent with the date in its name. If
#    you ever COPY snapshots in from elsewhere, mtime and name can disagree and
#    the copy will look newest; move them, or re-stamp them with touch -d.
while :; do
  total=$(du -sb "$ARCHIVE_DIR" | cut -f1)
  (( total <= MAX_BYTES )) && break

  mapfile -t by_age < <(
    find "$ARCHIVE_DIR" -maxdepth 1 -type f -name '*.zip' -printf '%T@\t%p\n' |
      sort -n | cut -f2-
  )
  if (( ${#by_age[@]} <= 1 )); then
    echo "Warning: $ARCHIVE_DIR is $(numfmt --to=iec "$total"), over the" \
         "${MAX_GB}G budget, but only one snapshot remains; keeping it." >&2
    break
  fi

  echo "Pruning $(du -h "${by_age[0]}" | cut -f1) $(basename "${by_age[0]}")"
  rm -- "${by_age[0]}"
done

# 3. Build the new archive, at a scratch name, so that a failed or interrupted
#    run can't leave a half-written archive at $ZIP -- and can't leave one that
#    a later run would silently append to.
#
#    Run from inside $SRC's parent and feed find(1) a relative path, so entries
#    are stored as enc/... rather than the home/jeff/ugh/enc/... that absolute
#    paths would produce (zip strips the leading / and warns).
#
#    find, not `zip -r`: -r has no way to skip sockets, and zip chokes on them.
#    Symlinks are deliberately NOT stored as symlinks (no -y), so zip follows
#    each one and stores a full copy of its target.
tmp="$ZIP.partial"
rm -f -- "$tmp"
(
  cd "$(dirname "$SRC")"
  find "$(basename "$SRC")" \( -type f -o -type d -o -type l \) ! -type s |
    zip -@ -0 "$tmp"
)
mv "$tmp" "$ZIP"
tmp=""   # built and installed; nothing left for cleanup to remove

# Report the archive folder in the same units the budget check used, so the
# number here can't disagree with the number that drove the pruning above.
final=$(du -sb "$ARCHIVE_DIR" | cut -f1)
echo "Wrote $(du -h "$ZIP" | cut -f1) to $ZIP"
echo "Snapshots now $(numfmt --to=iec "$final") of ${MAX_GB}G"
