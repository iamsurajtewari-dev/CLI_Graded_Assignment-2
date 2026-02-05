# Question 1 – Commands and Explanations

## Script setup

text
Command:
touch analyze.sh

Explanation:
This command creates an empty file named analyze.sh which will store my shell script for Question 1.

text
Command:
chmod +x analyze.sh

Explanation:
Here I give execute permission to analyze.sh so that I can run it as a shell script.

## Test data creation

text
Command:
echo -e "hello world\nthis is a test file" > sample.txt

Explanation:
This creates a sample text file with two lines of text. I will use this file to test the file analysis part of my script.

text
Command:
mkdir testdir

Explanation:
This makes a directory called testdir that I will use to test the directory analysis part of the script.

text
Command:
touch testdir/a.txt testdir/b.txt testdir/c.c

Explanation:
Here I create three files inside testdir, including two .txt files and one .c file, so the script can count total files and .txt files.

## Script execution commands

text
Command:
./analyze.sh

Explanation:
I ran the script without any arguments. The script checks the number of arguments and prints an error because it requires exactly one file or directory path.

text
Command:
./analyze.sh sample.txt

Explanation:
I passed sample.txt as the argument. The script detects it as a regular file using -f and uses wc to display the number of lines, words and characters in the file.

text
Command:
./analyze.sh testdir

Explanation:
This time I gave a directory name. The script detects it with -d and uses find and wc -l to print the total number of files and the number of .txt files inside that directory.

text
Command:
./analyze.sh nothing_here

Explanation:
I used a path that does not exist. The script finds that it is neither a file nor a directory and prints an error message saying the path does not exist.

