#!/bin/bash

# Check if emails.txt exists and is readable
if [ ! -f "emails.txt" ]; then
    echo "Error: emails.txt not found in current directory."
    exit 1
fi

if [ ! -r "emails.txt" ]; then
    echo "Error: emails.txt is not readable."
    exit 1
fi

# Extract valid emails: <letters_and_digits>@<letters>.com
grep -E '^[A-Za-z0-9][A-Za-z0-9]*@[A-Za-z][A-Za-z]*\.com$' emails.txt > valid_raw.txt

# Extract invalid emails (everything that is not valid)
grep -Ev '^[A-Za-z0-9][A-Za-z0-9]*@[A-Za-z][A-Za-z]*\.com$' emails.txt > invalid.txt

# Remove duplicates from valid list
sort valid_raw.txt | uniq > valid.txt

# Clean up temporary file
rm valid_raw.txt

echo "Valid email addresses are saved in valid.txt"
echo "Invalid email addresses are saved in invalid.txt"

