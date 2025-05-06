#!/bin/bash

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

# Make mrg directory if does not exist
mkdir -p ${HOME}/mrg/tutorial_ws/src

# Go to folder
cd ${HOME}/mrg/tutorial_ws/src

# Clone tutorial
git clone https://github.com/gt-marine-robotics-group/ROS_Tutorial.git

# Set up docker
mkdir -p ${HOME}/mrg/tutorial_docker_ws

cd ${HOME}/mrg/tutorial_docker_ws

# Clone docker tutorial branch
git clone -b tutorial https://github.com/Jeff300fang/MRG_Docker.git

cd MRG_Docker

echo "alias start_tutorial_docker='${HOME}/mrg/tutorial_docker_ws/MRG_Docker/session.sh'" >> ~/.bashrc

source ~/.bashrc

./session.sh






