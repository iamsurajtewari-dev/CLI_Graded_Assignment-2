# Question 6 – Commands and Explanations

## Creating input.txt

Command:  
`nano input.txt`  
Explanation: I opened the nano text editor to create the input file input.txt which will contain the text for word analysis.

Command (typed lines in nano):  
`I am a student of BITS PILANI ONLINE BSCS.`  
`I am learning Command Line Interface.`  
`This assignment calculates word metrics.`  
Explanation: I entered a few simple sentences so that the script can calculate longest word, shortest word, average word length, and the total number of unique words.

Command:  
`Ctrl+O`, `Enter`, `Ctrl+X`  
Explanation: I saved the content of input.txt and exited from nano.

Command:  
`cat input.txt`  
Explanation: I displayed the contents of input.txt on the screen to confirm that the text was stored correctly.

---

## Creating and preparing metrics.sh

Command:  
`nano metrics.sh`  
Explanation: I opened nano again to create the shell script metrics.sh which will read input.txt and compute the word metrics.

Command:  
*(inside nano I typed the full metrics.sh script and then saved and exited)*  
Explanation: I wrote the script that checks for input.txt, normalizes the text to one word per line, finds the longest and shortest words, calculates the average word length, and counts how many unique words appear in the file.

Command:  
`chmod +x metrics.sh`  
Explanation: I made the metrics.sh file executable using chmod so that I can run it directly with `./metrics.sh`.

---

## Running the script

Command:  
`./metrics.sh`  
Explanation: I executed the script in the Q6 folder. The script validated input.txt, processed all words, and then printed the file name, the longest word, the shortest word, the average word length (with two decimal places), and the total number of unique words. The output confirmed that the script correctly analyzed the text and produced the required metrics for Question 6.


# Question 6 – Code Explanation (metrics.sh)

```bash
#!/bin/bash
This line tells the system to execute the script using the bash shell.


file="input.txt"
I store the name of the input text file in a variable called file so that I can refer to it easily throughout the script.


# Check that input.txt exists and is readable
if [ ! -f "$file" ]; then
    echo "Error: $file not found in current directory."
    exit 1
fi
Here I check if input.txt exists as a regular file in the current directory. If it is missing, the script prints an error message and exits.


if [ ! -r "$file" ]; then
    echo "Error: $file is not readable."
    exit 1
fi
This part checks whether the file is readable. If there is no read permission, the script prints an error and stops instead of trying to process the file.


# Normalize text: one word per line, lowercase, remove punctuation
words=$(tr -sc 'A-Za-z' '\n' < "$file" | tr 'A-Z' 'a-z')
I use tr to replace all non‑letter characters with newlines, so the text becomes one word per line. Then I convert all letters to lowercase. The resulting list of words is stored in the variable words.


if [ -z "$words" ]; then
    echo "No words found in $file."
    exit 1
fi
If the words variable is empty, it means the file contained no valid words. In that case the script prints a message and exits.


# Longest and shortest word
longest_word=$(echo "$words" | awk '{print length, $0}' | sort -nr | head -n 1 | awk '{print $2}')
shortest_word=$(echo "$words" | awk '{print length, $0}' | sort -n  | head -n 1 | awk '{print $2}')
To find the longest and shortest words, I first print each word together with its length using awk. Then I sort by length in descending order (-nr) to get the longest word at the top, and in ascending order (-n) to get the shortest word. head -n 1 picks the first line, and the final awk '{print $2}' extracts just the word, not the length.


# Average word length
total_chars=$(echo "$words" | awk '{sum += length} END {print sum}')
total_words=$(echo "$words" | wc -l)
avg_length=$(echo "scale=2; $total_chars / $total_words" | bc)
Here I calculate the average word length. I use awk to add up the length of every word and print the total number of characters. Then wc -l counts how many words there are. Finally, I divide total characters by total words using bc with scale=2 so the result is shown with two decimal places.


# Total number of unique words
unique_count=$(echo "$words" | sort | uniq | wc -l)
To find the number of unique words, I sort the word list, remove duplicates with uniq, and then count the remaining lines using wc -l. This gives the total distinct words in the file.


echo "File analyzed: $file"
echo "Longest word:  $longest_word"
echo "Shortest word: $shortest_word"
echo "Average word length: $avg_length"
echo "Total unique words:  $unique_count"
At the end I print a small report that shows which file was analyzed and displays the longest word, the shortest word, the average word length, and the total number of unique words.
