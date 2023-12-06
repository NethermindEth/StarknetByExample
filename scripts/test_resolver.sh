#!/bin/bash

if [ ! -f $(which scarb) ]; then
  echo -e "${RED}No scarb executable found!${NC}"
  exit 1
fi

if [ ! -f $(which snforge) ]; then
  echo -e "${RED}No snforge executable found!${NC}"
  exit 1
fi

if [ ! -f Scarb.toml ]; then
  echo -e "${RED}No Scarb.toml file found!${NC}"
  exit 1
fi

if [ -z "$(grep -E 'snforge_std' Scarb.toml)" ]; then
  scarb cairo-test
else 
  snforge test
fi