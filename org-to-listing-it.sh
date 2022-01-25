#/bin/bash

# USAGE: <this script> <filename.org>
# Then send it to my cell, and open it in Listing It.
# PITFALL: It might need me to delete the first four spaces
# from every line.

# The backup function for sed renames the backup.
# I want the *changed* file to be the one with a new name;
# I want the old name to still point to the old content.
# So instead of using sed's "-i<extension>" option,
# I futz names myself, and edit in place ("-i").
# Since Listing It can only open .txt files,
# I need the stupid-looking "org.txt" extension.
target=$1.txt
cp $1 $target

# Put a dash after groups of stars.
# TODO ? I wish this only changed the first group of stars,
# not every group. I tried this instead:
#   sed -i -r "s/^([\*]) /\1- /g"
# but for some reason, that only changes the first line.
sed -i -r "s/(^|[\*]) /\1- /g" $target

# Replace all stars with space.
# TODO ? Similarly, it would be better if this only replaced leading stars.
sed -i -r "s/\*/    /g"           $target
