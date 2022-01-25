# du normally does not show hidden files.
# This way it does.
# It also sorts the results by size.

du -sch .[!.]* * | sort -h
