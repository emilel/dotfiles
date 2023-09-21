#!/bin/bash

if [[ -z "$1" ]]; then
  echo "Usage: $0 filename"
  exit 1
fi

FILENAME="$1"

if [[ ! -f "$FILENAME" ]]; then
  echo "File '$FILENAME' does not exist."
  exit 1
fi

FILE_BASENAME=$(basename "$FILENAME")
FILE_DIRNAME=$(dirname "$FILENAME")
FILE_EXTENSION="${FILE_BASENAME##*.}"
FILE_NAME="${FILE_BASENAME%.*}"

# Use `read` to provide a pre-filled input with the filename (without extension) selected
read -e -i "$FILE_NAME" -p "Enter new filename (without extension): " NEW_FILE_NAME

if [[ -z "$NEW_FILE_NAME" ]]; then
  echo "Filename cannot be empty"
  exit 1
fi

NEW_FILE_PATH="$FILE_DIRNAME/$NEW_FILE_NAME.$FILE_EXTENSION"

if [[ -e "$NEW_FILE_PATH" ]]; then
  echo "File '$NEW_FILE_PATH' already exists"
  exit 1
fi

mv "$FILENAME" "$NEW_FILE_PATH"
echo "File renamed to '$NEW_FILE_PATH'"

