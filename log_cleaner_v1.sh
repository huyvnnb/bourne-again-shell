#!/bin/bash

TARGET_DIR="$HOME/fake_logs"

DAY_TO_KEEP=14

echo "--- Log Cleanup Script ---"
echo "Target directory: ${TARGET_DIR}"
echo "Keeping files newer than ${DAYS_TO_KEEP} days."
echo ""

echo "Finding files to be deleted..."

find "${TARGET_DIR}" -type f -mtime +${DAY_TO_KEEP} -print

echo ""
echo "--- Script Finished ---"
echo "This was a dry run. No files were deleted."
