# Question 3 – Commands and Explanations

## Creating marks.txt

Command:  
`nano marks.txt`  
Explanation: I opened the nano text editor to create and edit a new file called marks.txt where I will store the students’ roll numbers, names and marks.

Command (typed lines in nano):  
`101,Anita,45,20,67`  
`102,Rahul,30,35,25`  
`103,Simran,70,80,65`  
`104,Amit,33,10,40`  
`105,Neha,50,32,34`  
Explanation: I entered sample student records in the format RollNo,Name,Marks1,Marks2,Marks3 so that the script can read the data and decide who has passed or failed.


Command:  
`cat marks.txt`  
Explanation: I displayed the contents of marks.txt on the screen to confirm that all five student records were saved correctly.

---

## Creating and preparing the script

Command:  
`nano validate_results.sh`  
Explanation: I opened nano again to create the shell script file validate_results.sh which will process the marks from marks.txt.

Command:  
*(inside nano I typed the full validate_results.sh script and then saved and exited)*  
Explanation: I wrote the script that checks for marks.txt, reads each student’s marks, counts how many subjects they failed, prints students who failed exactly one subject, prints students who passed all subjects, and shows the final counts.

Command:  
`ls`  
Explanation: I listed the files in the Q3 folder to verify that both marks.txt and validate_results.sh are present.

Command:  
`chmod +x validate_results.sh`  
Explanation: I used chmod with +x to make validate_results.sh executable so that I can run it directly with `./validate_results.sh`.

---

## Running the script

Command:  
`./validate_results.sh`  
Explanation: I executed my script in the Q3 folder. The script read marks.txt line by line, calculated how many subjects each student failed, printed the students who failed in exactly one subject, printed the students who passed in all three subjects, and finally showed the count for each category.

The output showed:
- The list of students who failed in exactly one subject.  
- The list of students who passed in all subjects.  
- The total number of students in each group, confirming that the script logic works correctly for the given data.




# Question 3 – Code Explanation (validate_results.sh)


#!/bin/bash
This line tells the system to run the script using the bash shell.


# Check if marks.txt exists and is readable
if [ ! -f "marks.txt" ]; then
    echo "Error: marks.txt not found in current directory."
    exit 1
fi
Here I check if the file marks.txt exists as a regular file in the current directory. If it is missing, the script prints an error message and stops.


if [ ! -r "marks.txt" ]; then
    echo "Error: marks.txt is not readable."
    exit 1
fi
This part checks if marks.txt is readable. If there is no read permission, the script shows an error and exits instead of continuing with a bad file.


pass_mark=33
fail_exactly_one=0
pass_all=0
I set the passing mark for each subject to 33 and create two counters: one for students who fail in exactly one subject and one for students who pass in all subjects. Both counters start from 0.


echo "Students who failed in exactly ONE subject:"
echo "------------------------------------------"
These echo lines print a heading so that the output clearly shows the section for students who failed in exactly one subject.


while IFS=',' read -r roll name m1 m2 m3
do
This while loop reads marks.txt line by line. I set the field separator to a comma, so each line is split into roll number, name and the three marks m1, m2 and m3.


    # Skip empty lines
    if [ -z "$roll" ]; then
        continue
    fi
If the line is empty (no roll number), I skip it using continue so that blank lines do not affect the calculation.


    fail_count=0
For each student I start a fresh fail counter, which will count how many subjects that student has failed.


    if [ "$m1" -lt "$pass_mark" ]; then
        fail_count=$((fail_count + 1))
    fi

    if [ "$m2" -lt "$pass_mark" ]; then
        fail_count=$((fail_count + 1))
    fi

    if [ "$m3" -lt "$pass_mark" ]; then
        fail_count=$((fail_count + 1))
    fi
In these three checks I compare each mark with the pass mark (33). Every time a mark is less than 33, I increase fail_count by 1. By the end, fail_count tells me how many subjects the student failed.


    if [ "$fail_count" -eq 1 ]; then
        echo "$roll, $name ($m1, $m2, $m3)"
        fail_exactly_one=$((fail_exactly_one + 1))
    fi
If a student has failed in exactly one subject, I print their roll, name and marks and increase the global counter fail_exactly_one by 1.


    if [ "$fail_count" -eq 0 ]; then
        pass_all=$((pass_all + 1))
    fi
If fail_count is 0, it means the student passed in all three subjects. I just increase the pass_all counter here; I print the list of passed students later.


done < marks.txt
This ends the first while loop and tells the shell to take its input from marks.txt.


echo
echo "Students who passed in ALL subjects:"
echo "------------------------------------"
I print a blank line and a new heading to start the section which lists students who passed in every subject.


while IFS=',' read -r roll name m1 m2 m3
do
I start a second loop over marks.txt, again reading roll number, name and three marks for each student.


    if [ -z "$roll" ]; then
        continue
    fi
As before, I skip any empty lines so they do not appear in the output.


    if [ "$m1" -ge "$pass_mark" ] && [ "$m2" -ge "$pass_mark" ] && [ "$m3" -ge "$pass_mark" ]; then
        echo "$roll, $name ($m1, $m2, $m3)"
    fi
Here I check that all three marks are greater than or equal to the pass mark. If the student has passed all three subjects, I print their details in this “passed in all subjects” section.


done < marks.txt
This ends the second loop, which also reads from marks.txt.


echo
echo "Summary counts:"
echo "---------------"
echo "Students who failed in exactly ONE subject: $fail_exactly_one"
echo "Students who passed in ALL subjects:        $pass_all"
Finally I print a summary. I show how many students failed in exactly one subject using fail_exactly_one and how many students passed in all subjects using pass_all, so the overall result of the script is easy to read.
