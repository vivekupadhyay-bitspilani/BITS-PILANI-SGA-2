#!/bin/bash

LOG_FILE="server.log"
REPORT_FILE="error_report.log"

# Clean up previous runs
rm -f "$LOG_FILE" "$REPORT_FILE"
touch "$LOG_FILE"

echo "=== Real-Time Server Log Monitoring Tool ==="
echo "Starting continuous command pipeline..."
echo "--------------------------------------------------"

# Real-time command pipeline running in background for simulation
# 1. tail -f: monitors newly appended log entries in real time
# 2. 2> /dev/null: suppresses unnecessary errors/warnings
# 3. grep --line-buffered: extracts ERROR lines instantly
# 4. tee -a: displays to terminal in real time AND appends to report file
tail -f "$LOG_FILE" 2> /dev/null | grep --line-buffered "ERROR" | tee -a "$REPORT_FILE" &
MONITOR_PID=$!

sleep 1

echo "[Simulating real-time log generation...]"
echo "[$(date +'%Y-%m-%d %H:%M:%S')] INFO: System initialized successfully." >> "$LOG_FILE"
sleep 1
echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: Database connection failed on port 5432." >> "$LOG_FILE"
sleep 1
echo "[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: High memory usage detected (88%)." >> "$LOG_FILE"
sleep 1
echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: Unauthorized access attempt from IP 192.168.1.105." >> "$LOG_FILE"
sleep 1
echo "[$(date +'%Y-%m-%d %H:%M:%S')] INFO: Cache re-indexed." >> "$LOG_FILE"
sleep 1
echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: Disk write timeout on partition /dev/sda1." >> "$LOG_FILE"

sleep 2

# Stop background monitoring process
kill $MONITOR_PID 2> /dev/null

echo "--------------------------------------------------"
echo "Monitoring simulation stopped."
echo ""
echo "=== Contents of Maintained Report File ('$REPORT_FILE') ==="
cat "$REPORT_FILE"
