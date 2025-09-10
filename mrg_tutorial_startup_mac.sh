#!/bin/bash

# Get users github username
read -p "Enter your GitHub username (for cloning your fork): " GH_USERNAME

# Check if user has forked both repositories
curl --silent --fail "https://github.com/${GH_USERNAME}/ROS_Tutorial" > /dev/null || { echo "Fork of ROS_Tutorial not found!"; exit 1; }
curl --silent --fail "https://github.com/${GH_USERNAME}/stinger-software" > /dev/null || { echo "Fork of stinger-software not found!"; exit 1; }

# Make mrg directory if does not exist
mkdir -p ${HOME}/mrg/tutorial_ws/src

# Go to folder
cd ${HOME}/mrg/tutorial_ws/src

# Clone tutorial
git clone https://github.com/${GH_USERNAME}/ROS_Tutorial.git

# Clone stinger-software
git clone https://github.com/${GH_USERNAME}/stinger-software.git

# Set up docker
mkdir -p ${HOME}/mrg/tutorial_docker_ws

cd ${HOME}/mrg/tutorial_docker_ws

# Clone docker tutorial branch
git clone -b tutorial https://github.com/Jeff300fang/MRG_Docker.git

cd MRG_Docker

# Create alias
echo "alias start_tutorial_docker='${HOME}/mrg/tutorial_docker_ws/MRG_Docker/session.sh'" >> ~/.zshrc
source ~/.zshrc

docker pull jeff300fang/mrg:jazzy_tutorial