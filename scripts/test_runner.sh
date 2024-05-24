#!/bin/bash

# root directory of the repository
REPO_ROOT="$(git rev-parse --show-toplevel)"

list_all_listings() {
  ls -d listings/ch*/* | grep -E 'listings/ch.*/*' | cut -d '/' -f 2-3
}

# function to process listing
process_listing() {
  local listing="$1"
  local dir_path="${REPO_ROOT}/listings/${listing}"

  if ! cd "$dir_path"; then
    echo -e "${RED}Failed to change to directory: $dir_path ${NC}"
    return
  fi

  $REPO_ROOT/scripts/test_resolver.sh
} 

for listing in $(list_all_listings); do
  process_listing "$listing"
done

wait