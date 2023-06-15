#!/bin/bash

IS_RUN_LOCALLY="$1"

GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

cd listings
mkdir -p output
rm -rf output/*

if [ "$IS_RUN_LOCALLY" = true ]; then
    echo -e "\nStarting Scarb build...\n"
else
    echo "# Scarb build"
    echo ""
    echo "The list of directories below is auto-generated from the markdown sources."
    echo ""
fi

has_error=false

for dir in ch*-*/**; do
  if [ -d "$dir" ]; then
    cd "$dir"
    scarb build > ../output/"$dir".out 2> ../output/"$dir".err

    build_code="$?"

    err="$(cat ../output/$dir.err)"

    if [ $build_code -ne 0 ]; then
        has_error=true

        if [ "$IS_RUN_LOCALLY" = true ]; then
            echo -e "\n---- ${RED}${dir}${NC} ----\n"
            echo "$err"
        else
            echo ":x: **$dir**"
            echo "<pre>$err</pre>"
        fi

        echo ""
        echo "---  "
        echo ""
    fi

    cd ../
  fi

done

if [ "$has_error" = false ] ; then
    if [ "$IS_RUN_LOCALLY" = true ]; then
        echo -e "\n${GREEN}All scarb builds were completed successfully${NC}.\n"
    else
        echo ":heavy_check_mark: All scarb builds were completed successfully."
        echo ""
    fi

    exit 0
else

    if [ "$IS_RUN_LOCALLY" = true ]; then
        echo -e "\n${RED}Some scarb builds have errors, please check the list above.${NC}\n"
    else
        echo ":x: Some scarb builds have errors, please check the list above."
        echo ""
    fi

    exit 1
fi
