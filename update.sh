#!/bin/bash

# Save any manual changes to the MRG_Docker configuration (mostly for the mrg_ws folder location)
git stash;

# Update MRG_Docker github
git pull;

# Reapply manual changes
git stash pop;

# Update docker container
docker pull jeff300fang/mrg;

