#!/bin/bash

if [[ -z "$1" ]]; then
  echo "Usage: $0 filename"
  exit 1
fi

FILENAME="$1"

if [[ ! -f "$FILENAME" ]]; then
  echo "File '$FILENAME' does not exist"
  exit 1
fi

BACKUP_FILENAME="$FILENAME.bak"

# Copy the original file to the backup file
cp "$FILENAME" "$BACKUP_FILENAME"

# Confirm to the user that the backup was created
echo "Backup created: '$BACKUP_FILENAME'"
