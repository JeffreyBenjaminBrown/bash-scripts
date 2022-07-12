#!/bin/bash

# To extract, go to the target destination (where the restored data should be put), and run something like this:
#   borg extract PATH_TO_REPO::ARCHIVE_NAME [SEARCH_PATTERN(S)]
# The search patterns are optional.
# For instance, to restore just ~/_stale, I did this:
#   borg extract /run/media/jeff/Samsung_T5/borg-data::2020-04-30 home/jeff/_stale

# Run these from the borg repo folder.

# borg create $(pwd)::critical_$(date +%Y-%m-%d) ~/ugh/enc

# PITFALL -- before running this, first detach anything that might be copied errneously,
# e.g. if encf mounts it in my home folder and it's not excluded by these options.
# echo I started running \"borg create\" at:
  echo $(date)
  cd /run/media/jeff/ssd_500g_samsung/borg-repo
  borg create $(pwd)::$(date +%Y-%m-%d).hp17 /home/jeff \
    --exclude-from /home/jeff/bin/exclude-for-borg.txt &
