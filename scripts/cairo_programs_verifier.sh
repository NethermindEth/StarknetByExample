#!/bin/bash

GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

# root directory of the repository
REPO_ROOT="$(git rev-parse --show-toplevel)"
error_file=$(mktemp)

# function to list modified cairo files
list_modified_cairo_files() {
    git diff --name-only main...HEAD -- listings | grep -E 'listings/ch.*/*.cairo$'
}

# function to process individual file
process_file() {
    local relative_path="$1"
    local dir_path="${REPO_ROOT}/$(dirname "${relative_path}")"
    local file_name=$(basename "$relative_path")

    if ! cd "$dir_path"; then
        echo "Failed to change to directory: $dir_path"
        echo "1" >> "$error_file"
        return
    fi

    if ! scarb build >error.log 2>&1; then
        cat error.log
        echo "1" >> "$error_file"
    fi

    if ! scarb fmt >>error.log 2>&1; then
        echo "Error in scarb format check for $file_name"
        cat error.log
        echo "1" >> "$error_file"
    fi

    if ! scarb test >>error.log 2>&1; then
        echo "Error in scarb test for $file_name"
        cat error.log
        echo "1" >> "$error_file"
    fi

    rm error.log
}

# process each modified file
pids=()
modified_files=$(list_modified_cairo_files)
for file in $modified_files; do
    process_file "$file" &
    pids+=($!)
done

# wait for all background processes to finish
for pid in ${pids[@]}; do
    wait $pid
done

# check if any errors were encountered
if grep -q "1" "$error_file"; then
    echo -e "\n${RED}Some projects have errors, please check the list above.${NC}\n"
    rm "$error_file"
    exit 1
else
    echo -e "\n${GREEN}All scarb builds were completed successfully${NC}.\n"
    rm "$error_file"
    exit 0
fi
