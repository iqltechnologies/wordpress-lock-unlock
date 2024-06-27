#!/bin/bash

# Check if the script received exactly one argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 {lock|unlock}"
    exit 1
fi

# Define the directories and files to be excluded from the operation
EXCLUDED_DIR="wp-content/uploads"
SCRIPT_NAME=$(basename "$0")

# Function to change attributes
change_attributes() {
    local operation=$1

    # Find and change attributes for all files and directories except the excluded ones
    find . -path "./$EXCLUDED_DIR" -prune -o -exec chattr "$operation" {} +
    
    # Change attribute for the script file itself
    chattr "$operation" "$SCRIPT_NAME"
}

case $1 in
    lock)
        # Make files and folders immutable
        change_attributes +i
        echo "All files and directories except $EXCLUDED_DIR have been locked."
        ;;
    unlock)
        # Make files and folders mutable
        change_attributes -i
        echo "All files and directories except $EXCLUDED_DIR have been unlocked."
        ;;
    *)
        echo "Invalid argument. Usage: $0 {lock|unlock}"
        exit 1
        ;;
esac
