rsync -av --progress input \
      --exclude a \
      --exclude b* \
      output


rsync -av --progress /home/jeff                         \
  --exclude .cabal                                    \
  --exclude .cache                                    \
  --exclude .local/share/Trash                        \
  --exclude .local/share/baloo                        \
  --exclude .stack                                    \
  --exclude Encfs/ugh                                 \
  --exclude javeriana/cities/output                   \
  --exclude javeriana/tax.co/data/*/older*/recip-*    \
  --exclude javeriana/tax.co/data/*/recip-*           \
  --exclude javeriana/tax.co/output/vat*              \
  --exclude probably-to-nuke                          \
  --exclude .sbt                                      \
  --exclude torrent                                   \
  /run/media/jeff/_Toshi-2020-2TB/unenc
