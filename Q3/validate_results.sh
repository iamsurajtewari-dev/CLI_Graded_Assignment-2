#!/bin/bash

# Check if marks.txt exists and is readable
if [ ! -f "marks.txt" ]; then
    echo "Error: marks.txt not found in current directory."
    exit 1
fi

if [ ! -r "marks.txt" ]; then
    echo "Error: marks.txt is not readable."
    exit 1
fi

pass_mark=33
fail_exactly_one=0
pass_all=0

echo "Students who failed in exactly ONE subject:"
echo "------------------------------------------"

while IFS=',' read -r roll name m1 m2 m3
do
    # Skip empty lines
    if [ -z "$roll" ]; then
        continue
    fi

    fail_count=0

    if [ "$m1" -lt "$pass_mark" ]; then
        fail_count=$((fail_count + 1))
    fi

    if [ "$m2" -lt "$pass_mark" ]; then
        fail_count=$((fail_count + 1))
    fi

    if [ "$m3" -lt "$pass_mark" ]; then
        fail_count=$((fail_count + 1))
    fi

    if [ "$fail_count" -eq 1 ]; then
        echo "$roll, $name ($m1, $m2, $m3)"
        fail_exactly_one=$((fail_exactly_one + 1))
    fi

    if [ "$fail_count" -eq 0 ]; then
        pass_all=$((pass_all + 1))
    fi

done < marks.txt

echo
echo "Students who passed in ALL subjects:"
echo "------------------------------------"

while IFS=',' read -r roll name m1 m2 m3
do
    if [ -z "$roll" ]; then
        continue
    fi

    if [ "$m1" -ge "$pass_mark" ] && [ "$m2" -ge "$pass_mark" ] && [ "$m3" -ge "$pass_mark" ]; then
        echo "$roll, $name ($m1, $m2, $m3)"
    fi
done < marks.txt

echo
echo "Summary counts:"
echo "---------------"
echo "Students who failed in exactly ONE subject: $fail_exactly_one"
echo "Students who passed in ALL subjects:        $pass_all"

