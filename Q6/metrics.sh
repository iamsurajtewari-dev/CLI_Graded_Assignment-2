#!/bin/bash

file="input.txt"

# Check that input.txt exists and is readable
if [ ! -f "$file" ]; then
    echo "Error: $file not found in current directory."
    exit 1
fi

if [ ! -r "$file" ]; then
    echo "Error: $file is not readable."
    exit 1
fi

# Normalize text: one word per line, lowercase, remove punctuation
words=$(tr -sc 'A-Za-z' '\n' < "$file" | tr 'A-Z' 'a-z')

if [ -z "$words" ]; then
    echo "No words found in $file."
    exit 1
fi

# Longest and shortest word
longest_word=$(echo "$words" | awk '{print length, $0}' | sort -nr | head -n 1 | awk '{print $2}')
shortest_word=$(echo "$words" | awk '{print length, $0}' | sort -n  | head -n 1 | awk '{print $2}')

# Average word length
total_chars=$(echo "$words" | awk '{sum += length} END {print sum}')
total_words=$(echo "$words" | wc -l)
avg_length=$(echo "scale=2; $total_chars / $total_words" | bc)

# Total number of unique words
unique_count=$(echo "$words" | sort | uniq | wc -l)

echo "File analyzed: $file"
echo "Longest word:  $longest_word"
echo "Shortest word: $shortest_word"
echo "Average word length: $avg_length"
echo "Total unique words:  $unique_count"

