#!/bin/bash

TARGET_DIR="$HOME/fake_logs"
DAYS_TO_KEEP=14

echo "--- Interactive Log Cleanup Script ---"

files=$(find "$TARGET_DIR" -type f -mtime +${DAYS_TO_KEEP})

for file_to_delete in $files; do
	read -p "Delete this file? -> ${file_to_delete} [y/N]: " confirm
	if [[ -n "${confirm}" && "${confirm,,}" == "y" ]]; then
		echo "Deleting file: ${file_to_delete}"
		rm -v "${file_to_delete}"
	else
		echo "Skip file: ${file_to_delete}"

	fi
done

echo "--- Cleanup Finished ---"

