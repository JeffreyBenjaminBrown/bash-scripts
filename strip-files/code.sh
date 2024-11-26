#!/bin/bash

# Check if both files are provided
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 big-list.txt files-to-strip.txt"
    exit 1
fi

big_list=$1
files_to_strip=$2

# Ensure both files exist
if [[ ! -f $big_list || ! -f $files_to_strip ]]; then
    echo "Error: One or both input files do not exist."
    exit 1
fi

# Use grep to filter out lines from big-list.txt that match any line in files-to-strip.txt
grep -vFf "$files_to_strip" "$big_list"
