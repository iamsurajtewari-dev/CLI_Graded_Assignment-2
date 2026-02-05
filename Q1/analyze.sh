#!/bin/bash

# Check if exactly one argument is provided
if [ $# -ne 1 ]; then
    echo "Error: Provide exactly one argument."
    exit 1
fi

# If the argument is a regular file
if [ -f "$1" ]; then
    echo "File analysis:"
    # Show number of lines, words and characters in the file
    wc "$1"

# If the argument is a directory
elif [ -d "$1" ]; then
    echo "Directory analysis:"
    # Count all files inside the directory
    echo "Total files: $(find "$1" -type f | wc -l)"
    # Count only .txt files inside the directory
    echo "Text files: $(find "$1" -type f -name "*.txt" | wc -l)"

# If it is neither a file nor a directory
else
    echo "Error: Path does not exist."
    exit 1
fi

