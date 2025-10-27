#!/bin/bash

SOURCE_DIR="/home/ec2-user/data"
BACKUP_DIR="/tmp/backups"
LOG_FILE="/var/log/backup_report.log"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="backup_${DATE}.tar.gz"

mkdir -p "$BACKUP_DIR"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a "$LOG_FILE"
}

log_message "Starting backup for directory: $SOURCE_DIR"

# Step 1: Create backup archive
tar -czf "$BACKUP_DIR/$BACKUP_FILE" -C "$SOURCE_DIR" . 2>>"$LOG_FILE"
if [ $? -eq 0 ]; then
    log_message "Backup archive created: $BACKUP_FILE"
else
    log_message "Backup creation failed!"
    exit 1
fi

# Step 2: Store backup locally
mkdir -p /root/local-backups
mv "$BACKUP_DIR/$BACKUP_FILE" /root/local-backups/
if [ $? -eq 0 ]; then
    log_message "Backup stored locally at /root/local-backups/$BACKUP_FILE"
else
    log_message "Local backup move failed!"
    exit 1
fi

# Step 3: Remove backups older than 7 days
find /root/local-backups -type f -name "*.tar.gz" -mtime +7 -exec rm -f {} \;
log_message "Old backups older than 7 days have been removed."

log_message "Backup operation completed successfully."

