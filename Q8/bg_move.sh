#!/bin/bash

# Check argument: directory path
if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory_path>"
    exit 1
fi

dir="$1"

# Validate directory
if [ ! -d "$dir" ]; then
    echo "Error: '$dir' is not a directory."
    exit 1
fi

# Create backup/ subdirectory if not exists
backup_dir="$dir/backup"
mkdir -p "$backup_dir"

echo "Moving files from '$dir' to '$backup_dir' in background..."

pids=""

for f in "$dir"/*; do
    # Skip the backup directory itself
    if [ "$f" = "$backup_dir" ]; then
        continue
    fi

    if [ -f "$f" ]; then
        mv "$f" "$backup_dir/" &
        pid=$!
        echo "Started background move for '$f' with PID: $pid"
        pids="$pids $pid"
    fi
done

echo
echo "Waiting for all background moves to finish..."

wait $pids

echo "All background moves completed."

