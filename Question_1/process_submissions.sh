#!/bin/bash

SUBMISSION_DIR="./submissions"
BACKUP_DIR="./backup"
REPORT_FILE="./summary_report.txt"
ERROR_LOG="./errors.log"

mkdir -p "$BACKUP_DIR"
exec 2>> "$ERROR_LOG"

processed_count=0
duplicate_count=0
backup_count=0

HASH_TEMP=$(mktemp)

if [ ! -d "$SUBMISSION_DIR" ]; then
    echo "Error: Submissions directory '$SUBMISSION_DIR' not found." >&2
    exit 1
fi

for file in "$SUBMISSION_DIR"/*; do
    if [ -f "$file" ]; then
        ((processed_count++))
        file_hash=$(md5sum "$file" | awk '{print $1}')

        if grep -q "$file_hash" "$HASH_TEMP"; then
            ((duplicate_count++))
            echo "Duplicate file detected: $(basename "$file")"
        else
            echo "$file_hash" >> "$HASH_TEMP"
            cp "$file" "$BACKUP_DIR/"
            ((backup_count++))
        fi
    fi
done

rm -f "$HASH_TEMP"

{
    echo "=========================================="
    echo "     SUBMISSION PROCESSING REPORT        "
    echo "=========================================="
    echo "Files Processed  : $processed_count"
    echo "Duplicates Found : $duplicate_count"
    echo "Unique Backed Up : $backup_count"
    echo "Report Date      : $(date)"
    echo "=========================================="
} > "$REPORT_FILE"

echo "Task completed successfully. Report saved to $REPORT_FILE."
