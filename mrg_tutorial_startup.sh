#!/bin/bash

# Get users github username
read -p "Enter your GitHub username (for cloning your fork): " GH_USERNAME

# Check if user has forked both repositories
curl --silent --fail "https://github.com/${GH_USERNAME}/ROS_Tutorial" > /dev/null || { echo "Fork of ROS_Tutorial not found!"; exit 1; }
curl --silent --fail "https://github.com/${GH_USERNAME}/stinger-software" > /dev/null || { echo "Fork of stinger-software not found!"; exit 1; }

# Install docker
sudo apt-get update -y
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Start docker
sudo systemctl start docker
sudo systemctl enable docker

# Add user to docker group
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

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
echo "alias start_tutorial_docker='${HOME}/mrg/tutorial_docker_ws/MRG_Docker/session.sh'" >> ~/.bashrc
source ~/.bashrc

docker pull jeff300fang/mrg:jazzy_tutorial
