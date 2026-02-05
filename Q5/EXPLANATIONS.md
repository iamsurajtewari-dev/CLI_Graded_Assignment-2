# Question 5 – Commands and Explanations

## Creating the test directories and files

Command:  
`mkdir dirA dirB`  
Explanation: I created two directories named dirA and dirB which will be used as the two folders to compare in this question.

Command:  
`echo "file in A only" > dirA/onlyA.txt`  
Explanation: I created a file onlyA.txt inside dirA that exists only in dirA so that the script can show a file present only in dirA.

Command:  
`echo "same content" > dirA/common1.txt`  
Explanation: I created a file common1.txt in dirA with the text “same content”; there will be a file with the same name and content in dirB to test matching contents.

Command:  
`echo "different content in A" > dirA/common2.txt`  
Explanation: I created another common file common2.txt in dirA but with content that will be different from the file of the same name in dirB.

Command:  
`echo "file in B only" > dirB/onlyB.txt`  
Explanation: I created a file onlyB.txt inside dirB that exists only in dirB so the script can show a file present only in dirB.

Command:  
`echo "same content" > dirB/common1.txt`  
Explanation: I created common1.txt in dirB with exactly the same text as dirA/common1.txt so that the script should report their contents as SAME.

Command:  
`echo "different content in B" > dirB/common2.txt`  
Explanation: I created common2.txt in dirB with different text compared to dirA/common2.txt so that the script should report their contents as DIFFERENT.

Command:  
`echo "dirA:"`  
`ls dirA`  
Explanation: I printed a label and listed the files in dirA to verify that onlyA.txt, common1.txt and common2.txt were created correctly.

Command:  
`ls dirB`  
Explanation: I listed the files in dirB to confirm that onlyB.txt, common1.txt and common2.txt exist there.

---

## Creating and preparing sync.sh

Command:  
`nano sync.sh`  
Explanation: I opened the nano editor to create the shell script sync.sh which will compare dirA and dirB.

Command:  
*(inside nano I typed the full sync.sh script and then saved and exited)*  
Explanation: I wrote the script that checks the two directory arguments, lists files present only in each directory, and for files with the same name uses cmp to check whether their contents are the same or different.

Command:  
`chmod +x sync.sh`  
Explanation: I made the sync.sh file executable using chmod so that I can run it directly with `./sync.sh`.

---

## Running the script

Command:  
`./sync.sh dirA dirB`  
Explanation: I executed the script by passing dirA as the first directory and dirB as the second. The script printed the files present only in dirA (onlyA.txt), the files present only in dirB (onlyB.txt), and then compared common1.txt and common2.txt in both directories using cmp, reporting that common1.txt contents are SAME and common2.txt contents are DIFFERENT. This shows that the script correctly compares the two directories without copying or modifying any files.



# Question 5 – Code Explanation (sync.sh)

```bash
#!/bin/bash
This line tells the system to execute the script using the bash shell.


# Check if exactly two arguments are given
if [ $# -ne 2 ]; then
    echo "Usage: $0 <dirA> <dirB>"
    exit 1
fi
Here I check that the user has provided exactly two command‑line arguments. If the number of arguments is not 2, the script prints a usage message showing the correct way to run it and then exits with an error.


dirA="$1"
dirB="$2"
I store the first argument in dirA and the second in dirB so that I can refer to these directory paths easily in the rest of the script.


# Check that both arguments are directories
if [ ! -d "$dirA" ]; then
    echo "Error: '$dirA' is not a directory."
    exit 1
fi

if [ ! -d "$dirB" ]; then
    echo "Error: '$dirB' is not a directory."
    exit 1
fi
These checks make sure that both arguments are valid directories. If either path is not a directory, the script prints an error message and stops instead of continuing with wrong inputs.


echo "Files present only in $dirA:"
echo "----------------------------"
comm -23 <(ls -1 "$dirA" | sort) <(ls -1 "$dirB" | sort)
First I print a heading for the files that exist only in dirA. Then I use ls -1 to list one file per line from each directory, sort the lists, and pass them to comm. The option -23 tells comm to show only lines unique to the first list, so this prints the files present only in dirA.


echo
echo "Files present only in $dirB:"
echo "----------------------------"
comm -13 <(ls -1 "$dirA" | sort) <(ls -1 "$dirB" | sort)
Here I print a heading for files that exist only in dirB. Using comm again, the option -13 hides lines from the first list and common lines, so the output shows files that are unique to dirB.


echo
echo "Files with the same name in both directories (content comparison):"
echo "------------------------------------------------------------------"
This prints a blank line and a heading for the section where I compare files that have the same name in both directories.


common_files=$(comm -12 <(ls -1 "$dirA" | sort) <(ls -1 "$dirB" | sort))
Here I use comm -12 on the sorted file lists. This option hides unique lines and shows only the lines that are common to both lists, so common_files contains the names of files that exist in both dirA and dirB.


if [ -z "$common_files" ]; then
    echo "No common files to compare."
else
If common_files is empty, there are no files with the same name in both directories, so I print a simple message. Otherwise I go into the else block to compare them.


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
I loop over each common file name f. For safety I check that the file exists in both directories. Then I use cmp -s to compare the contents of the two files silently: if the contents match, cmp returns success and I print that the contents are SAME; otherwise I print that the contents are DIFFERENT. The script only reads the files and reports the result, it does not copy or modify anything.
