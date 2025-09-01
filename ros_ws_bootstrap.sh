#!/bin/bash

# Update package lists
apt-get update -y

# Install required ROS2 packages
rosdep install -y --from-paths /root/mrg_ws/src --ignore-src

# Source ROS2 setup
source /opt/ros/jazzy/setup.bash
