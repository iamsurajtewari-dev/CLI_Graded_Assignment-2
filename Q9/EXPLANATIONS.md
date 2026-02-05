# Question 9 – Commands and Explanations

## Creating the C program

Command:  
`nano zombie_prevent.c`  
Explanation: I opened the nano text editor to create the C source file zombie_prevent.c which will demonstrate how to prevent zombie processes.

Command:  
*(inside nano I typed the full zombie_prevent.c program and then saved and exited)*  
Explanation: I wrote a C program where the parent process creates multiple child processes using fork(), each child prints messages, sleeps for some time and exits, and the parent later calls waitpid() for each child to clean them up so they do not remain as zombies.

---

## Compiling the program

Command:  
`gcc zombie_prevent.c -o zombie_prevent`  
Explanation: I used the gcc compiler to compile the source file zombie_prevent.c and create an executable named zombie_prevent. If there are no syntax errors, this command produces the binary file.

---

## Running the program

Command:  
`./zombie_prevent`  
Explanation: I executed the compiled program. The parent process printed messages when creating each child with its PID. Then each child process printed when it started and when it was exiting. After that, the parent called waitpid() in a loop for each child PID and printed messages like “Parent cleaned up child with PID …”. Finally, the parent printed that it cleaned up all children and would now exit, demonstrating that all child processes were properly reaped and no zombies were left.



# Question 9 – Code Explanation (zombie_prevent.c)

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
These header files provide the functions and types used in the program: standard I/O, general utilities, process-related functions like fork(), getpid(), sleep(), and the wait/waitpid functions for cleaning up child processes.

int main(void) {
    int num_children = 3;
    pid_t pids;
The main function starts here. I declare num_children as 3 to create three child processes, and an array pids to store the process IDs of each child.

    for (int i = 0; i < num_children; i++) {
        pid_t pid = fork();
I use a for-loop to call fork() three times. Each time, fork() creates a new child process and returns its PID to the parent, or 0 to the child.

        if (pid < 0) {
            perror("fork failed");
            exit(1);
If pid is less than 0, the fork failed. In that case I print an error message using perror() and exit with status 1.

        } else if (pid == 0) {
            // Child process
            printf("Child %d started with PID %d\n", i + 1, getpid());
            sleep(2 + i);  // simulate some work
            printf("Child %d (PID %d) exiting\n", i + 1, getpid());
            exit(0);
If pid is 0, we are inside the child process. The child prints a message with its own PID, sleeps for a few seconds to simulate some work, prints another message when it is about to exit, and then calls exit(0) to terminate cleanly.

        } else {
            // Parent process
            pids[i] = pid;
            printf("Parent created child %d with PID %d\n", i + 1, pid);
        }
    }
If pid is greater than 0, we are still in the parent process. The parent stores the child’s PID in the pids array and prints a message saying that it created that child. The loop then continues to create the next child.

    // Parent: reap all children to prevent zombies
    int status;
    pid_t wpid;
After the loop, only the parent reaches this part. I declare status to receive the child’s exit status and wpid to hold the PID returned by waitpid().

    for (int i = 0; i < num_children; i++) {
        wpid = waitpid(pids[i], &status, 0);
        if (wpid > 0) {
            printf("Parent cleaned up child with PID %d\n", wpid);
        } else {
            perror("waitpid failed");
        }
    }
The parent loops over all stored child PIDs and calls waitpid() for each one. waitpid() waits for the specific child to finish and reaps it, so it does not remain a zombie. If waitpid() returns a positive PID, the parent prints a message that it cleaned up that child; otherwise it prints an error.

    printf("Parent (PID %d) cleaned up all children and will now exit.\n", getpid());

    return 0;
}
Finally, the parent prints a message saying that it has cleaned up all children and will now exit.
