# Question 4: Real-Time Log Monitoring and Analysis Utility

## Overview
This solution designs a real-time Linux command pipeline to monitor system log files continuously. It streams newly appended log entries in real time, isolates `ERROR` entries, maintains a dedicated error report file, and suppresses unnecessary error/warning output using standard stream redirection to `/dev/null`.

---

## Command Pipeline Design

```bash
tail -f server.log 2> /dev/null | grep --line-buffered "ERROR" | tee -a error_report.log
