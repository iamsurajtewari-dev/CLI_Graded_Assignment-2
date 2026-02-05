# Question 7 – Commands and Explanations

## Creating the input file

Command:  
`nano words.txt`  
Explanation: I opened the nano text editor to create a text file called words.txt which will contain the words to be classified into vowels, consonants and mixed.

Command (typed sample words in nano):  
`apple ORANGE sky rhythm fly IDEA bcd queue crypt strong`  
Explanation: I entered a mix of words containing only vowels, only consonants, and a combination of both, using different cases, so that the script can separate them into the required categories.


---

## Creating and preparing patterns.sh

Command:  
`nano patterns.sh`  
Explanation: I opened nano again to create the shell script patterns.sh which will read words.txt and write the words into vowels.txt, consonants.txt and mixed.txt.

Command:  
*(inside nano I typed the full patterns.sh script and then saved and exited)*  
Explanation: I wrote the script that checks the input file, converts all words to lowercase, splits them into one word per line, and then uses pattern matching to send only-vowel words to vowels.txt, only-consonant words to consonants.txt, and words starting with a consonant but containing both vowels and consonants to mixed.txt.

Command:  
`chmod +x patterns.sh`  
Explanation: I used chmod with +x to make patterns.sh executable so that I can run it directly using `./patterns.sh`.

---

## Running the script

Command:  
`./patterns.sh words.txt`  
Explanation: I executed the script and passed words.txt as the input file. The script processed each word and created three output files, then printed messages saying that words containing only vowels are saved in vowels.txt, words containing only consonants are saved in consonants.txt, and words with both vowels and consonants starting with a consonant are saved in mixed.txt.


# Question 7 – Code Explanation (patterns.sh)

```bash
#!/bin/bash
This line tells the system to execute the script using the bash shell.


# Check argument: input file
if [ $# -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi
Here I check that exactly one command‑line argument is given. If the number of arguments is not 1, the script prints a usage message showing how to run it and exits with an error.


file="$1"
I store the first argument, which should be the input text file, in a variable called file so I can reuse the name easily.

# Validate file
if [ ! -f "$file" ]; then
    echo "Error: '$file' does not exist or is not a regular file."
    exit 1
fi

if [ ! -r "$file" ]; then
    echo "Error: '$file' is not readable."
    exit 1
fi
These checks make sure that the given path is a regular file and that it is readable. If the file does not exist or cannot be read, the script prints an error message and stops instead of continuing with bad input.


# Clear/initialize output files
> vowels.txt
> consonants.txt
> mixed.txt
I use redirection with > to create or empty the three output files. This ensures that each run of the script starts with fresh vowels.txt, consonants.txt and mixed.txt.


# Process words: lowercase, one word per line
tr -sc 'A-Za-z' '\n' < "$file" | tr 'A-Z' 'a-z' | while read -r w; do
Here I normalize the input text. tr -sc 'A-Za-z' '\n' replaces non‑letter characters with newlines, giving one word per line. Then I convert everything to lowercase with tr 'A-Z' 'a-z'. The resulting stream of words is fed into a while loop that reads each word into the variable w.


    # Skip empty
    [ -z "$w" ] && continue
If for some reason the word is empty, I skip it using continue so that blank lines are ignored.


    # Check patterns
    if echo "$w" | grep -Eq '^[aeiou]+$'; then
        echo "$w" >> vowels.txt
This condition checks whether the word contains only vowels. The regular expression ^[aeiou]+$ means one or more vowel characters from start to end of the word. If it matches, I append the word to vowels.txt.


    elif echo "$w" | grep -Eq '^[bcdfghjklmnpqrstvwxyz]+$'; then
        echo "$w" >> consonants.txt
The second condition checks for words made up only of consonants using the consonant character set. If it matches, I append the word to consonants.txt.


    elif echo "$w" | grep -Eq '^[bcdfghjklmnpqrstvwxyz][a-z]*[aeiou][a-z]*$'; then
        echo "$w" >> mixed.txt
The third condition looks for words that start with a consonant and contain at least one vowel somewhere in the rest of the word. If this pattern is matched, the word has both vowels and consonants and starts with a consonant, so I append it to mixed.txt.


    fi
done
This closes the if block and the while loop, so all words from the input file are processed and written to the correct output files.


echo "Words containing ONLY vowels are in vowels.txt"
echo "Words containing ONLY consonants are in consonants.txt"
echo "Words with both vowels and consonants starting with a consonant are in mixed.txt"
At the end, I print three messages to the terminal telling the user where the words of each category have been saved: only vowels in vowels.txt, only consonants in consonants.txt, and mixed words in mixed.txt.

