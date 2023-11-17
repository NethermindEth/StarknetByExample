#!/bin/bash

GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

# flag to check if any errors were encountered
has_errors=false

# function to list modified cairo files
list_modified_cairo_files() {
    git diff --name-only master...HEAD -- listings | grep -E 'listings/ch.*/*.cairo$'
}

echo -e "\n${GREEN}Modified files:${NC}"

# function to process individual file
process_file() {
    dir=$(dirname "$1")
    file=$(basename "$1")
    echo "Processing $dir/$file"
    (cd "$dir" && scarb build "$file" 0>/dev/null 1> error.log && scarb fmt -c "$file" 0>/dev/null 1>> error.log && scarb test "$file" 0>/dev/null 1>> error.log)
    if [ $? -ne 0 ]; then
        has_errors=true
        echo "Error while processing $dir/$file"
        cat "$dir/error.log"
    fi
    rm "$dir/error.log"
}

# process each modified file
modified_files=$(list_modified_cairo_files)
for file in $modified_files; do
    process_file "$file" &
done

wait  # Wait for all background processes to finish

# check if any errors were encountered
if $has_errors ; then
  echo -e "\n${RED}Some projects have errors, please check the list above.${NC}\n"
  exit 1
else
  echo -e "\n${GREEN}All scarb builds were completed successfully${NC}.\n"
  exit 0
fi
