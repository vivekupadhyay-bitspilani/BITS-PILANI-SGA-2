#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <signal.h>

#define TIMEOUT 3 // Timeout threshold in seconds

// Function to monitor child process execution
void monitor_child(pid_t child_pid) {
    int status;
    int elapsed = 0;

    printf("[Parent PID %d] Monitoring Child Process PID %d...\n", getpid(), child_pid);

    while (elapsed < TIMEOUT) {
        // Non-blocking check to see if child process has exited
        pid_t result = waitpid(child_pid, &status, WNOHANG);

        if (result == 0) {
            // Child is still running, wait 1 second
            sleep(1);
            elapsed++;
            printf("[Parent] Waiting for Child PID %d... (%d sec)\n", child_pid, elapsed);
        } else if (result == child_pid) {
            // Child exited normally before timing out
            if (WIFEXITED(status)) {
                printf("[Parent] Child PID %d completed normally (Exit status: %d).\n", child_pid, WEXITSTATUS(status));
            }
            return;
        } else {
            perror("waitpid error");
            return;
        }
    }

    // Child exceeded timeout threshold -> Unresponsive process detected
    printf("[Parent] Child PID %d TIMED OUT! Unresponsive process detected.\n", child_pid);
    printf("[Parent] Sending SIGKILL signal to terminate Child PID %d...\n", child_pid);
    
    // Send termination signal
    kill(child_pid, SIGKILL);

    // Immediately reap child status to prevent a Zombie process
    waitpid(child_pid, &status, 0);
    if (WIFSIGNALED(status)) {
        printf("[Parent] Child PID %d reaped successfully (Killed by Signal %d). Zombie state prevented!\n", child_pid, WTERMSIG(status));
    }
}

int main() {
    printf("=== Web Server Child Process Monitor ===\n\n");

    // Scenario 1: Responsive Child Process (Simulating fast request)
    pid_t pid1 = fork();
    if (pid1 == 0) {
        printf("[Child 1 PID %d] Processing request (Responsive)...\n", getpid());
        sleep(1); // Finish quickly within 1 second
        exit(0);
    } else if (pid1 > 0) {
        monitor_child(pid1);
    } else {
        perror("Fork failed for Child 1");
    }

    printf("\n----------------------------------------\n\n");

    // Scenario 2: Unresponsive Child Process (Simulating hanging request)
    pid_t pid2 = fork();
    if (pid2 == 0) {
        printf("[Child 2 PID %d] Processing request (Hanging / Unresponsive)...\n", getpid());
        while(1) {
            sleep(1); // Infinite loop simulating frozen process
        }
    } else if (pid2 > 0) {
        monitor_child(pid2);
    } else {
        perror("Fork failed for Child 2");
    }

    printf("\nAll child process monitoring tasks finished.\n");
    return 0;
}
