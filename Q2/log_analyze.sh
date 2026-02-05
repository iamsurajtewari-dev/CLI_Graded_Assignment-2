#!/bin/bash

# Check if exactly one argument is given
if [ $# -ne 1 ]; then
    echo "Usage: $0 <log_file>"
    exit 1
fi

log_file="$1"

# Check if file exists and is a regular file
if [ ! -f "$log_file" ]; then
    echo "Error: '$log_file' does not exist or is not a regular file."
    exit 1
fi

# Check if file is readable
if [ ! -r "$log_file" ]; then
    echo "Error: '$log_file' is not readable."
    exit 1
fi

# Total number of log entries
total_entries=$(wc -l < "$log_file")

# Count INFO, WARNING and ERROR messages
info_count=$(grep -c " INFO " "$log_file")
warning_count=$(grep -c " WARNING " "$log_file")
error_count=$(grep -c " ERROR " "$log_file")

# Most recent ERROR message
latest_error=$(grep " ERROR " "$log_file" | tail -n 1)

# Report file name: logsummary_<date>.txt
current_date=$(date +%Y-%m-%d)
report_file="logsummary_${current_date}.txt"

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

# Display results on screen
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
echo
echo "Report saved to: $report_file"

