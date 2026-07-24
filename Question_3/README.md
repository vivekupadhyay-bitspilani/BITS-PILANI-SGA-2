# Question 3: Low-Level Secure File Processing Utility

## Overview
This solution implements a low-level, secure file-processing utility for employee records using raw Linux System Calls (`open`, `read`, `write`, `lseek`, `close`) instead of buffered C standard library I/O functions. It demonstrates file creation, sequential binary writes, targeted random-access retrievals, and in-place record updates without rewriting the entire dataset.

---

## Executed Commands, Outputs & Mandatory Explanations

### 1. Source Compilation
```bash
gcc file_utility.c -o file_utility
