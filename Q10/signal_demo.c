#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <sys/types.h>

volatile sig_atomic_t terminate_flag = 0;

void handle_sigterm(int sig) {
    (void)sig;
    printf("Parent: Received SIGTERM, starting graceful shutdown...\n");
    terminate_flag = 1;
}

void handle_sigint(int sig) {
    (void)sig;
    printf("Parent: Received SIGINT, cleaning up and exiting immediately...\n");
    terminate_flag = 1;
}

int main(void) {
    pid_t child1, child2;

    printf("Parent: PID %d, starting and will run until signals arrive.\n", getpid());

    if (signal(SIGTERM, handle_sigterm) == SIG_ERR) {
        perror("Error setting SIGTERM handler");
        exit(1);
    }
    if (signal(SIGINT, handle_sigint) == SIG_ERR) {
        perror("Error setting SIGINT handler");
        exit(1);
    }

    child1 = fork();
    if (child1 < 0) {
        perror("fork failed");
        exit(1);
    } else if (child1 == 0) {
        printf("Child 1 (PID %d): will send SIGTERM to parent after 5 seconds.\n", getpid());
        sleep(5);
        kill(getppid(), SIGTERM);
        printf("Child 1 (PID %d): sent SIGTERM to parent and will exit.\n", getpid());
        exit(0);
    }

    child2 = fork();
    if (child2 < 0) {
        perror("fork failed");
        exit(1);
    } else if (child2 == 0) {
        printf("Child 2 (PID %d): will send SIGINT to parent after 10 seconds.\n", getpid());
        sleep(10);
        kill(getppid(), SIGINT);
        printf("Child 2 (PID %d): sent SIGINT to parent and will exit.\n", getpid());
        exit(0);
    }

    while (!terminate_flag) {
        printf("Parent: still running (PID %d)...\n", getpid());
        sleep(1);
    }

    printf("Parent: exiting gracefully now.\n");
    return 0;
}

