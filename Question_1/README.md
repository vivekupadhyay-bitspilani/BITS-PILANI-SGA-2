# Question 1: Automated Submission & Duplicate Management System

## Task Overview
This project provides an automated shell script solution designed to scan student lab assignment submissions, identify duplicate files using cryptographic content hashing (`md5sum`), create backups of unique files, generate a clean execution report, and isolate standard errors into a separate log file.

---

## Executed Commands, Outputs & Mandatory Explanations

### 1. Setup Test Submissions Directory and Files
```bash
mkdir -p submissions
echo "Student Assignment Content A" > submissions/assign1.txt
echo "Student Assignment Content A" > submissions/assign2_dup.txt
echo "Student Assignment Content B" > submissions/assign3.txt
