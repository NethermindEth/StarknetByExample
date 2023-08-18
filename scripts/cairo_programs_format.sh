#!/bin/bash

GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

process_directory() {
  for dir in "$1"/*
  do
    if [ -d "$dir" ]; then
      echo "Processing $dir"
      (cd "$dir" && scarb fmt)
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

echo -e "\n${GREEN}Formats finished.${NC}.\n"
exit 0
