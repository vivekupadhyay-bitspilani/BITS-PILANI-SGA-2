# Question 2: Web Server Process Monitoring and Management System

## Task Overview
This program models a Linux-based web server monitoring system. It spawns child worker processes using `fork()`, continuously monitors their runtimes without blocking execution using non-blocking `waitpid()` calls, terminates unresponsive processes via signals (`SIGKILL`), and reaps exited/killed children to prevent zombie processes from cluttering the system process table.

---

## Executed Commands, Outputs & Mandatory Explanations

### 1. Compile C Program
```bash
gcc process_monitor.c -o process_monitor
