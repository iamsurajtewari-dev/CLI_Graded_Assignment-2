#!/bin/bash

# Check argument: input file
if [ $# -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

file="$1"

# Validate file
if [ ! -f "$file" ]; then
    echo "Error: '$file' does not exist or is not a regular file."
    exit 1
fi

if [ ! -r "$file" ]; then
    echo "Error: '$file' is not readable."
    exit 1
fi

# Clear/initialize output files
> vowels.txt
> consonants.txt
> mixed.txt

# Process words: lowercase, one word per line
tr -sc 'A-Za-z' '\n' < "$file" | tr 'A-Z' 'a-z' | while read -r w; do
    # Skip empty
    [ -z "$w" ] && continue

    # Check patterns
    if echo "$w" | grep -Eq '^[aeiou]+$'; then
        echo "$w" >> vowels.txt
    elif echo "$w" | grep -Eq '^[bcdfghjklmnpqrstvwxyz]+$'; then
        echo "$w" >> consonants.txt
    elif echo "$w" | grep -Eq '^[bcdfghjklmnpqrstvwxyz][a-z]*[aeiou][a-z]*$'; then
        echo "$w" >> mixed.txt
    fi
done

echo "Words containing ONLY vowels are in vowels.txt"
echo "Words containing ONLY consonants are in consonants.txt"
echo "Words with both vowels and consonants starting with a consonant are in mixed.txt"

