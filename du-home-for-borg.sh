# Based on du-biggest-recursive.sh,
# which is *almost* more general, but it excludes nothing.
du -a /home/jeff                                        \
     --exclude-from=/home/jeff/bin/exclude-for-borg.txt \
    | sort -n -r                                        \
    | head -n 300
