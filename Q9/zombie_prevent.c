#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

int main(void) {
    int num_children = 3;
    pid_t pids[3];

    for (int i = 0; i < num_children; i++) {
        pid_t pid = fork();

        if (pid < 0) {
            perror("fork failed");
            exit(1);
        } else if (pid == 0) {
            // Child process
            printf("Child %d started with PID %d\n", i + 1, getpid());
            sleep(2 + i);  // simulate some work
            printf("Child %d (PID %d) exiting\n", i + 1, getpid());
            exit(0);
        } else {
            // Parent process
            pids[i] = pid;
            printf("Parent created child %d with PID %d\n", i + 1, pid);
        }
    }

    // Parent: reap all children to prevent zombies
    int status;
    pid_t wpid;

    for (int i = 0; i < num_children; i++) {
        wpid = waitpid(pids[i], &status, 0);
        if (wpid > 0) {
            printf("Parent cleaned up child with PID %d\n", wpid);
        } else {
            perror("waitpid failed");
        }
    }

    printf("Parent (PID %d) cleaned up all children and will now exit.\n", getpid());

    return 0;
}

