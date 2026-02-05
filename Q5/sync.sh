#!/bin/bash

# Check if exactly two arguments are given
if [ $# -ne 2 ]; then
    echo "Usage: $0 <dirA> <dirB>"
    exit 1
fi

dirA="$1"
dirB="$2"

# Check that both arguments are directories
if [ ! -d "$dirA" ]; then
    echo "Error: '$dirA' is not a directory."
    exit 1
fi

if [ ! -d "$dirB" ]; then
    echo "Error: '$dirB' is not a directory."
    exit 1
fi

echo "Files present only in $dirA:"
echo "----------------------------"
comm -23 <(ls -1 "$dirA" | sort) <(ls -1 "$dirB" | sort)

echo
echo "Files present only in $dirB:"
echo "----------------------------"
comm -13 <(ls -1 "$dirA" | sort) <(ls -1 "$dirB" | sort)

echo
echo "Files with the same name in both directories (content comparison):"
echo "------------------------------------------------------------------"

common_files=$(comm -12 <(ls -1 "$dirA" | sort) <(ls -1 "$dirB" | sort))

if [ -z "$common_files" ]; then
    echo "No common files to compare."
else
    echo "$common_files" | while read -r f; do
        if [ -f "$dirA/$f" ] && [ -f "$dirB/$f" ]; then
            if cmp -s "$dirA/$f" "$dirB/$f"; then
                echo "$f : contents are SAME"
            else
                echo "$f : contents are DIFFERENT"
            fi
        fi
    done
fi

