# USAGE
# Supply two arguments:
#   (1) The root of the folder tree to scour.
#   (2) How many results to return.
# This will find the $2 biggest subfolders.

du -a $1 | sort -n -r | head -n $2
# example:
# du -a . | sort -n -r | head -n 20
