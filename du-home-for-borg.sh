EXCLUDE=/home/jeff/bin/exclude-for-borg.txt
OUTPUT=/home/jeff/org-roam/pers/memory_used_in_home_folder.org

# Based on du-biggest-recursive.sh,
# which is *almost* more general, but it excludes nothing.
VERBOSE=$(mktemp)
du -a -Bk                    \
    /home/jeff               \
     --exclude-from=$EXCLUDE \
    | sort -n -r             \
    | head -n 500 \
    > $VERBOSE

# Remove every line from VERBOSE containing an entire line from EXCLUDE
# See `strip-files/` for more detail and test data.
grep -vFf $EXCLUDE $VERBOSE > $OUTPUT
