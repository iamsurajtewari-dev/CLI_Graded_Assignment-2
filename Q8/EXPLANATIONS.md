# Question 8 – Commands and Explanations

## Creating the test directory and files

Command:  
`mkdir testdir`  
Explanation: I created a directory named testdir which will be used as the input directory for the bg_move.sh script.

Command:  
`echo "file one" > testdir/file1.txt`  
Explanation: I created a text file file1.txt inside testdir with some sample content so that it can be moved to the backup folder.

Command:  
`echo "file two" > testdir/file2.txt`  
Explanation: I created another file file2.txt in testdir with different content.

Command:  
`echo "file three" > testdir/file3.txt`  
Explanation: I created a third file file3.txt in testdir so that the script has multiple files to move in the background.

---

## Creating and preparing bg_move.sh

Command:  
`nano bg_move.sh`  
Explanation: I opened the nano text editor to create the shell script bg_move.sh which will move all files from a given directory into its backup subdirectory using background processes.

Command:  
*(inside nano I typed the full bg_move.sh script and then saved and exited)*  
Explanation: I wrote the script that checks the directory argument, creates a backup/ subdirectory, starts a background mv command for each file, prints the PID for every background move, and then waits for all of them to finish.

Command:  
`chmod +x bg_move.sh`  
Explanation: I used chmod with +x to make bg_move.sh executable so that I can run it directly using `./bg_move.sh`.

---

## Running the script

Command:  
`./bg_move.sh testdir`  
Explanation: I executed the script and passed testdir as the directory to process. The script created testdir/backup if needed, started separate background processes to move file1.txt, file2.txt and file3.txt into the backup folder, printed the PID of each background mv command, and then waited until all background moves were completed before printing the final message “All background moves completed.”


# Question 8 – Code Explanation (bg_move.sh)

```bash
#!/bin/bash
This line tells the system to execute the script using the bash shell.


# Check argument: directory path
if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory_path>"
    exit 1
fi
Here I check that exactly one command‑line argument is given. If the number of arguments is not 1, the script prints a usage message showing how to run it and then exits with an error.


dir="$1"
I store the first argument, which should be the directory to process, in a variable called dir so that I can refer to it easily later in the script.

h
# Validate directory
if [ ! -d "$dir" ]; then
    echo "Error: '$dir' is not a directory."
    exit 1
fi
This part checks that the given path is an existing directory. If it is not a directory, the script prints an error message and stops instead of continuing with invalid input.


# Create backup/ subdirectory if not exists
backup_dir="$dir/backup"
mkdir -p "$backup_dir"
I define the backup directory path as <dir>/backup and use mkdir -p to create it if it does not already exist. The -p option avoids errors if the directory is already there.


echo "Moving files from '$dir' to '$backup_dir' in background..."

pids=""
I print a message explaining what the script is about to do and initialize an empty variable pids which will later store the process IDs of all background move operations.


for f in "$dir"/*; do
    # Skip the backup directory itself
    if [ "$f" = "$backup_dir" ]; then
        continue
    fi
I start a loop over every item inside the given directory. If the current item is the backup subdirectory itself, I skip it with continue so that the script does not try to move the backup folder.


    if [ -f "$f" ]; then
        mv "$f" "$backup_dir/" &
        pid=$!
        echo "Started background move for '$f' with PID: $pid"
        pids="$pids $pid"
    fi
done
For each regular file, I run mv to move it into the backup directory, but I add & to send the move operation into the background. Immediately after that, $! gives the PID of the last background process, which I store in pid and print for the user. I also append this PID to the pids list so that I can wait for all of them later.


echo
echo "Waiting for all background moves to finish..."
I print a blank line and a message to indicate that the script will now wait for all background moves to complete.


wait $pids
The wait command pauses the script until all background processes whose PIDs are in the pids variable have finished. This ensures that the script does not exit before all move operations are done.


echo "All background moves completed."
Finally, I print a confirmation message.
