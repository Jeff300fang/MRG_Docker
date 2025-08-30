#!/bin/bash
# Source ROS
source /opt/ros/jazzy/setup.bash

# Initialize workspace if needed
cd /root/mrg_ws

# Install dependencies
rosdep update
rosdep install --from-paths src --ignore-src -r -y

# Launch bash or continue to user command
exec "$@"

