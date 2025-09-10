#!/bin/bash

# Update package lists
apt-get update -y

# Install required ROS2 packages
rosdep install -y --from-paths /root/mrg_ws/src --ignore-src

# Install missing packages
apt-get install ros-jazzy-robot-localization -y
apt-get install ros-jazzy-tf-transformations -y
apt-get install ros-jazzy-urdfdom-py -y

# Source ROS2 setup
source /opt/ros/jazzy/setup.bash
