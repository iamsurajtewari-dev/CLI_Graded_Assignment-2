# Question 4 – Commands and Explanations

## Creating emails.txt

Command:  
`nano emails.txt`  
Explanation: I opened the nano text editor to create a new file called emails.txt where I will store a list of email addresses to be checked.

Command (typed lines in nano):  
`anita123@example.com`  
`rahul@test.com`  
`bad-email`  
`user_1@domain.org`  
`1234@abc.com`  
`john@site.com`  
`john@site.com`  
`name@site`  
`abc@xyz.com`  
Explanation: I entered a mix of valid-looking and invalid email strings so that the script can separate correct addresses from incorrect ones and also handle duplicates.

Command:  
`Ctrl+O`, `Enter`, `Ctrl+X`  
Explanation: I saved the contents of emails.txt and exited from the nano editor.

Command:  
`cat emails.txt`  
Explanation: I displayed the emails.txt file on the screen to confirm that all the email entries were stored correctly.

---

## Creating and preparing the script

Command:  
`nano emailcleaner.sh`  
Explanation: I opened nano again to create the shell script file emailcleaner.sh which will process emails.txt and generate valid.txt and invalid.txt.

Command:  
*(inside nano I typed the full emailcleaner.sh script and then saved and exited)*  
Explanation: I wrote the script that checks for emails.txt, uses grep with a simple pattern to select valid emails, writes invalid emails separately, removes duplicate valid entries using sort and uniq, and shows where the results are stored.

Command:  
`ls`  
Explanation: I listed the files in the Q4 folder to verify that both emails.txt and emailcleaner.sh are present.

Command:  
`chmod +x emailcleaner.sh`  
Explanation: I used chmod with +x to make emailcleaner.sh executable so that I can run it directly with `./emailcleaner.sh`.

---

## Running the script and checking outputs

Command:  
`./emailcleaner.sh`  
Explanation: I executed the script. It checked that emails.txt exists and is readable, then created valid_raw.txt and invalid.txt using grep, removed duplicate valid emails into valid.txt, deleted the temporary file, and printed messages indicating where the valid and invalid email addresses were saved.

Command:  
`cat valid.txt`  
Explanation: I displayed valid.txt to see the list of email addresses that matched the pattern `<letters_and_digits>@<letters>.com` after duplicates were removed.

Command:  
`cat invalid.txt`  
Explanation: I displayed invalid.txt to verify that all the remaining entries (which do not match the simple .com pattern) were correctly identified as invalid emails.


# Question 4 – Code Explanation (emailcleaner.sh)

```bash
#!/bin/bash
This line tells the system to execute the script using the bash shell.


# Check if emails.txt exists and is readable
if [ ! -f "emails.txt" ]; then
    echo "Error: emails.txt not found in current directory."
    exit 1
fi
Here I check whether the file emails.txt exists as a regular file in the current directory. If it is missing, the script prints an error message and stops.


if [ ! -r "emails.txt" ]; then
    echo "Error: emails.txt is not readable."
    exit 1
fi
This part checks if emails.txt is readable. If there is no read permission, the script prints an error and exits instead of continuing with a file it cannot read.


# Extract valid emails: <letters_and_digits>@<letters>.com
grep -E '^[A-Za-z0-9][A-Za-z0-9]*@[A-Za-z][A-Za-z]*\.com$' emails.txt > valid_raw.txt
In this command I use grep -E (extended regular expressions) to select “valid” email addresses.
The pattern matches lines that start with one or more letters/digits, followed by @, then one or more letters, and ending with .com. All matching lines are written to a temporary file valid_raw.txt.


# Extract invalid emails (everything that is not valid)
grep -Ev '^[A-Za-z0-9][A-Za-z0-9]*@[A-Za-z][A-Za-z]*\.com$' emails.txt > invalid.txt
Here I use grep -Ev with the same pattern but inverted. It selects all lines from emails.txt that do not match the valid-email pattern and writes them into invalid.txt, so this file contains the invalid email entries.


# Remove duplicates from valid list
sort valid_raw.txt | uniq > valid.txt
First I sort the valid emails so that duplicate lines come together. Then I pipe the result into uniq, which removes duplicates, and save the final unique list of valid addresses into valid.txt.


# Clean up temporary file
rm valid_raw.txt
After creating valid.txt, I no longer need the temporary file valid_raw.txt, so I delete it using rm to keep the folder clean.


echo "Valid email addresses are saved in valid.txt"
echo "Invalid email addresses are saved in invalid.txt"
Finally, I print two messages on the screen to tell the user that the valid email addresses are stored in valid.txt and the invalid ones are stored in invalid.txt, so it is clear where to find each result.
