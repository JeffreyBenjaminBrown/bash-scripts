# du normally does not show hidden files.
# This way it does.

du -sch .[!.]* * | sort -h
