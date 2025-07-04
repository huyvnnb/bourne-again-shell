#!/bin/bash

SOURCE_FILE="$HOME/config/config.txt"

TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_DIR="$HOME/backups"
BACKUP_FILE="config_$TIMESTAMP"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_FILE"
LOG_FILE="$HOME/backup.log"
RETENTION_DAYS=7

mkdir -p "$BACKUP_DIR"

if [ -f "$SOURCE_FILE" ]; then
	echo "Found $SOURCE_FILE"
	cp "$SOURCE_FILE" "$BACKUP_PATH"
	echo "Backup created at: $BACKUP_PATH" | tee -a "$LOG_FILE"
else
	echo "File $SOURCE_FILE does not exist" | tee -a "$LOG_FILE"
	exit 1
fi

find "$BACKUP_DIR" -type f -mtime +$RETENTION_DAYS -exec rm {} \;
echo "[$TIMESTAMP] Old backup older than $RETENTION_DAYS days deleted" | tee -a "$LOG_FILE"

echo "========END TASK========="
