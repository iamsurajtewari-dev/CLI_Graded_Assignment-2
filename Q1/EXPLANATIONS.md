# Question 1 – Script Creation and Testing

## Step 1: Creating the script file

```bash
touch analyze.sh
```

**Explanation:**
I created an empty **script** file named `analyze.sh` in the current directory so that I can write my Bash code inside it.

---

## Step 2: Making the script executable

```bash
chmod +x analyze.sh
```

**Explanation:**
I changed the file permissions of `analyze.sh` to make it **executable**, so that it can be run directly from the terminal using `./analyze.sh`.

---

## Step 3: Editing the script with nano

```bash
nano analyze.sh
```

**Explanation:**
I opened the `analyze.sh` file in the **nano** text editor to write the Bash script that will analyze files and directories.

---

## Step 4: Script code – argument validation

```bash
#!/bin/bash

# Check if exactly one argument is provided
if [ $# -ne 1 ]; then
    echo "Error: Provide exactly one argument."
    exit 1
fi
```

**Explanation:**
I started the script with the Bash **shebang** so it runs with `/bin/bash`. Then I checked the number of arguments using `#$`. If it is not exactly one, the script prints an error message and exits with status `1`.

---

## Step 5: Script code – handling a regular file

```bash
# If the argument is a regular file
if [ -f "$1" ]; then
    echo "File analysis:"
    # Show number of lines, words and characters in the file
    wc "$1"
```

**Explanation:**
Here I checked if the argument is a **regular file** using `-f "$1"`. If true, the script prints a heading and uses the `wc` command to display the number of lines, words, and characters of that file.

---

## Step 6: Script code – handling a directory

```bash
# If the argument is a directory
elif [ -d "$1" ]; then
    echo "Directory analysis:"
    # Count all files inside the directory
    echo "Total files: $(find "$1" -type f | wc -l)"
    # Count only .txt files inside the directory
    echo "Text files: $(find "$1" -type f -name "*.txt" | wc -l)"
```

**Explanation:**
If the argument is not a file, I check whether it is a **directory** using `-d "$1"`. For a directory, I first count all regular files inside it using `find` piped to `wc -l`, then I count only `.txt` files using `find` with `-name "*.txt"` and again `wc -l`.

---

## Step 7: Script code – invalid path

```bash
# If it is neither a file nor a directory
else
    echo "Error: Path does not exist."
    exit 1
fi
```

**Explanation:**
If the argument is neither a file nor a directory, the script prints an error message saying that the path does not exist and exits with status `1` to indicate failure.

---

## Step 8: Testing with no arguments

```bash
./analyze.sh
```

**Observation/Explanation:**
I ran the script without any arguments to test the validation. The script displayed `Error: Provide exactly one argument.` and exited, which confirms that the argument-count check is working correctly.

---

## Step 9: Testing with a regular file

```bash
echo -e "hello world\nthis is a test file" > sample.txt
./analyze.sh sample.txt
```

**Explanation:**
First I created a sample **text** file `sample.txt` with two lines of content using `echo -e` and output redirection. Then I ran the script with `sample.txt` as the argument. The script printed `File analysis:` followed by the `wc` output showing the number of lines, words, and characters, which verifies the file-handling part.

---

## Step 10: Testing with a directory

```bash
mkdir testdir
touch testdir/a.txt testdir/b.txt testdir/c.c
./analyze.sh testdir
```

**Explanation:**
I created a directory named `testdir` and added two `.txt` files and one `.c` file inside it. Running the script with `testdir` printed `Directory analysis:`, the total number of files as `3`, and the number of text files as `2`, confirming that the directory and `.txt` counting logic works as expected.

---

## Step 11: Testing with a non‑existent path

```bash
./analyze.sh nothing_here
```

**Explanation:**
I ran the script with a path that does not exist. The script responded with `Error: Path does not exist.` and exited, which shows that it correctly handles invalid or missing paths.

