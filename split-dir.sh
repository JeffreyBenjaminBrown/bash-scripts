#!/bin/bash

# PURPOSE:
# Split a directory into subfolders with no more than 500 folders each.

dir_size=500
dir_name="folder"

n=$((`find . -maxdepth 1 -type f | wc -l`/$dir_size+1))
for i in `seq 1 $n`;
do
    mkdir -p "$dir_name$i";
    find . -maxdepth 1 -type f \
	| head -n $dir_size \
	| xargs -i mv "{}" "$dir_name$i"
done
