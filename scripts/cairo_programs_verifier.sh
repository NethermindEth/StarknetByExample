#!/bin/bash

GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

# flag to check if any errors were encountered
has_errors=false

# function to process directory
process_directory() {
  for dir in "$1"/*
  do
    if [ -d "$dir" ]; then
      echo "Processing $dir"
      (cd "$dir" && scarb build 0>/dev/null 1> error.log)
      if [ $? -ne 0 ]; then
        has_errors=true
        echo "Error while processing $dir"
        cat "$dir/error.log"
      fi
      rm "$dir/error.log"
    fi
  done
}

# only start processing directories that match the pattern ch*-* 
for dir in listings/ch*-*
do
  if [ -d "$dir" ]; then
    process_directory "$dir"
  fi
done

# check if any errors were encountered
if $has_errors ; then
  echo "\n${RED}Some scarb builds have errors, please check the list above.${NC}\n"
  exit 1
else
  echo -e "\n${GREEN}All scarb builds were completed successfully${NC}.\n"
  exit 0
fi
