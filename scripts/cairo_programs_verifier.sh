#!/bin/bash

GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

git_setup() {
  upstream="git@github.com:NethermindEth/StarknetByExample.git"
  if git remote | grep -q "^upstream$"; then
    upstream_url=$(git remote get-url upstream)
    if [ "$upstream_url" != "$upstream" ]; then
      git remote set-url upstream "$upstream"
      echo "'upstream' remote URL updated to NethermindEth."
    fi
  else
      git remote add upstream "$desired_url"
      echo "'upstream' remote added to NethermindEth."
  fi
  git fetch upstream
}

# root directory of the repository
REPO_ROOT="$(git rev-parse --show-toplevel)"
error_file=$(mktemp)

# function to list modified listings
list_modified_listings() {
  git diff --name-only upstream/main -- listings | \
    grep -E 'listings/ch.*/*' | \
    cut -d '/' -f 2-3 | sort -u
}

list_all_listings() {
  ls -d listings/ch*/* | grep -E 'listings/ch.*/*' | cut -d '/' -f 2-3
}

# function to process listing
process_listing() {
  echo "Processing listing '$listing'"
  local listing="$1"
  local dir_path="${REPO_ROOT}/listings/${listing}"

  if ! cd "$dir_path"; then
    echo -e "${RED}Failed to change to directory: $dir_path ${NC}"
    echo "1" >> "$error_file"
    return
  fi

  if ! scarb build >error.log 2>&1; then
    echo -e "${RED}scarb build:${NC}"
    cat error.log
    echo "1" >> "$error_file"
  else
    if ! scarb fmt -c >>error.log 2>&1; then
      echo -e "${RED}scarb fmt:${NC}"
      cat error.log
      echo "1" >> "$error_file"
    fi

    if ! scarb test >>error.log 2>&1; then
      echo -e "${RED}scarb test:${NC}"
      cat error.log
      echo "1" >> "$error_file"
    fi
  fi

  if [ -f "error.log" ]; then
    rm error.log
  fi
}

# is there the -f flag?
force=false
if [ "$1" == "-f" ]; then
  force=true
fi

# process each modified file
pids=()

if [ "$force" = true ]; then
  modified_listings=$(list_all_listings)
else
  modified_listings=$(list_modified_listings)
fi
for listing in $modified_listings; do
  process_listing "$listing"
done

# check if any errors were encountered
if grep -q "1" "$error_file"; then
  echo -e "\n${RED}Some listings have errors, please check the list above.${NC}"
  rm "$error_file"
  exit 1
else
  if [ -z "$modified_listings" ]; then
    echo -e "\n${GREEN}No new changes detected${NC}"
  else
    echo -e "\n${GREEN}All $listings_count builds were completed successfully${NC}"
  fi
  rm "$error_file"
  exit 0
fi
