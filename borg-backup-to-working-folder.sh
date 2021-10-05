#!/bin/bash

# to extract, go to the target destination (where the restored data should be put), and run something like this:
#   borg extract PATH_TO_REPO::ARCHIVE_NAME [SEARCH_PATTERN(S)]
# The search patterns are optional.
# For instance, to restore just ~/_stale, I did this:
#   borg extract /run/media/jeff/Samsung_T5/borg-data::2020-04-30 home/jeff/_stale

# Run these from the borg repo folder.

# borg create $(pwd)::critical_$(date +%Y-%m-%d) ~/ugh/enc

# PITFALL -- before running this, first detach Encfs/ugh, and anything else like that.
# borg create $(pwd)::$(date +%Y-%m-%d) /home/jeff              \
  --exclude '/home/jeff/.cabal'                                 \
  --exclude '/home/jeff/.cache'                                 \
  --exclude '/home/jeff/.local/share/Trash'                     \
  --exclude '/home/jeff/.local/share/baloo'                     \
  --exclude '/home/jeff/.stack'                                 \
  --exclude '/home/jeff/.config/BraveSoftware/Brave-Browser/Default/Service Worker/CacheStorage' \
  --exclude '/home/jeff/.config/google-chrome/Default/Service Worker/CacheStorage' \
  --exclude '/home/jeff/ugh/enc.zip'                            \
  --exclude '/home/jeff/ugh/une'                                \
  --exclude '/home/jeff/javeriana/cities/output'                \
  --exclude '/home/jeff/javeriana/tax.co/data/*/older*/recip-*' \
  --exclude '/home/jeff/javeriana/tax.co/data/*/recip-*'        \
  --exclude '/home/jeff/javeriana/tax.co/output/vat*'           \
  --exclude '/home/jeff/probably-to-nuke'                       \
  --exclude '/home/jeff/.sbt'                                   \
  --exclude '/home/jeff/Videos'                                 \
  --exclude '/home/jeff/torrent'
