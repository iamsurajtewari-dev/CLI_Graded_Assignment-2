# Question 2 – Commands and Explanations

## Script creation and permissions

Command:  
`nano log_analyze.sh`  
Explanation: I opened the nano editor to create a new shell script file named log_analyze.sh for Question 2.

Command:  
*(inside nano I typed the full script for analyzing the log file and then saved and exited)*  
Explanation: I wrote the script that checks the argument, validates the log file, counts INFO/WARNING/ERROR messages, finds the latest ERROR, and generates the logsummary_<date>.txt report.

Command:  
`chmod +x log_analyze.sh`  
Explanation: I made the log_analyze.sh file executable so that I can run it directly using `./log_analyze.sh`.

---

## Creating a sample log file

Command:  
`cat > sample.log`  
Explanation: I started creating a sample log file named sample.log so that I can test my script with the same format as given in the question.

Command (typed lines):  
`2025-01-12 10:15:22 INFO System started`  
`2025-01-12 10:16:01 ERROR Disk not found`  
`2025-01-12 10:16:45 WARNING High memory usage`  
`2025-01-12 10:17:10 ERROR Network timeout`  
Explanation: I entered four log entries in the required format (date, time, level, message) to include INFO, WARNING and multiple ERROR messages.

Command:  
`Ctrl+D`  
Explanation: I pressed Ctrl+D to finish input to cat so that the lines are saved into the file sample.log.

---

## Running the script and generating the report

Command:  
`ls`  
Explanation: I listed the contents of the Q2 folder to verify that both log_analyze.sh and sample.log are present before running the script.

Command:  
`./log_analyze.sh sample.log`  
Explanation: I ran my script on sample.log. The script checked that I passed exactly one argument, confirmed that the file exists and is readable, counted total log entries and INFO/WARNING/ERROR messages, found the most recent ERROR line, and created a report file named logsummary_<today>.txt.

Command:  
`ls`  
Explanation: I listed the files again to confirm that the report file logsummary_<today>.txt was created successfully by the script.

Command:  
`cat logsummary_$(date +%Y-%m-%d).txt`  
Explanation: I opened the generated report file to check that it correctly shows the total number of log entries, the counts of INFO/WARNING/ERROR messages, and the most recent ERROR message from the log.



## Code explanation for log_analyze.sh


#!/bin/bash
This line tells the system that this file is a bash shell script and should be run using the bash interpreter.


# Check if exactly one argument is given
if [ $# -ne 1 ]; then
    echo "Usage: $0 <log_file>"
    exit 1
fi
Here I check that the user has given exactly one command‑line argument. If the number of arguments is not 1, the script prints a simple usage message showing how to run it and then exits with an error.


log_file="$1"
I store the first command‑line argument (the log file name) in a variable called log_file so that I can use this name easily in the rest of the script.


# Check if file exists and is a regular file
if [ ! -f "$log_file" ]; then
    echo "Error: '$log_file' does not exist or is not a regular file."
    exit 1
fi
This part checks whether the given path is a normal file. If it does not exist or is not a regular file, the script prints an error message and exits, so it does not try to work on an invalid file.


# Check if file is readable
if [ ! -r "$log_file" ]; then
    echo "Error: '$log_file' is not readable."
    exit 1
fi
Here I make sure that the file is readable. If the script does not have permission to read the log file, it shows a clear error and stops instead of failing later.


# Total number of log entries
total_entries=$(wc -l < "$log_file")
I use wc -l to count how many lines are present in the log file. Each line is one log entry, so I save this value in the variable total_entries.


# Count INFO, WARNING and ERROR messages
info_count=$(grep -c " INFO " "$log_file")
warning_count=$(grep -c " WARNING " "$log_file")
error_count=$(grep -c " ERROR " "$log_file")
These three commands count how many lines in the log file contain INFO, WARNING and ERROR. I use grep -c to get just the number of matching lines and store the results in separate variables for each log level.


# Most recent ERROR message
latest_error=$(grep " ERROR " "$log_file" | tail -n 1)
To find the most recent error, I first filter only the lines that have ERROR and then take the last one using tail -n 1. This last ERROR line is saved in latest_error.


# Report file name: logsummary_<date>.txt
current_date=$(date +%Y-%m-%d)
report_file="logsummary_${current_date}.txt"
In this part I generate today’s date in the format YYYY-MM-DD and store it in current_date. Then I use that value to build the report file name logsummary_<date>.txt.


# Write summary to report file
{
    echo "Log Summary Report"
    echo "Generated on: $current_date"
    echo "Source file: $log_file"
    echo
    echo "Total log entries: $total_entries"
    echo "INFO messages: $info_count"
    echo "WARNING messages: $warning_count"
    echo "ERROR messages: $error_count"
    echo
    echo "Most recent ERROR message:"
    if [ -n "$latest_error" ]; then
        echo "$latest_error"
    else
        echo "No ERROR entries found in the log."
    fi
} > "$report_file"
This block creates the actual summary report. I print a small header, then the total number of entries and the counts for INFO, WARNING and ERROR. After that, I print a heading for the most recent error and either show the last ERROR line or a message saying that there are no errors. All this output is redirected into the report file whose name I prepared earlier.


# Display results on screen
echo "Total log entries: $total_entries"
echo "INFO messages: $info_count"
echo "WARNING messages: $warning_count"
echo "ERROR messages: $error_count"
Here I show the same basic statistics on the terminal so that the user can immediately see the results without opening the report file.


echo "Most recent ERROR message:"
if [ -n "$latest_error" ]; then
    echo "$latest_error"
else
    echo "No ERROR entries found in the log."
fi
In this part I display the most recent ERROR line on the screen. If there was no ERROR in the file, the script clearly says that no ERROR entries were found.


echo "Report saved to: $report_file"
Finally, I print the name of the summary report file so that the user knows which file was created and where to look for the detailed output.
