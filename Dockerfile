# set up runtime container
FROM --platform=$TARGETARCH tiryoh/ros2-desktop-vnc:humble
ENV ROS_DISTRO=humble
ENV GZ_VERSION=garden
SHELL ["/bin/bash", "-c"]

# Uninstall the old ignition version of Gazebo 
RUN apt-get update && apt-get  purge ros-humble-gazebo-ros-pkgs ros-humble-ros-ign -y || true && apt autoremove -y

# Install Gazebo Garden
RUN wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null \
    && apt-get update \
    && apt-get install gz-garden --no-install-recommends -y

# Prepare to build ros_gz from source (The 3rd party apt package is not provided for ARM)
RUN mkdir -p /opt/ros_gz_ws/src && cd /opt/ros_gz_ws && git clone --branch humble https://github.com/gazebosim/ros_gz.git ./src

# Install ros_gz dependencies
RUN rosdep install -r --from-paths /opt/ros_gz_ws/ -i -y --rosdistro humble

# Build ros_gz
RUN cd /opt/ros_gz_ws/ && source /opt/ros/humble/setup.bash && colcon build --packages-up-to ros_gz

# set user to root
USER root
ENV USER=root \
    HOME=/root

# install runtime dependencies, vim, gedit, and xacro
RUN apt-get update && apt-get install --no-install-recommends -y \
    libgoogle-glog-dev python3-dev python3-pip python3-numpy vim python3-sdformat13 \
    gedit ros-humble-xacro ros-humble-rosbridge-suite python-is-python3
RUN pip3 install transforms3d
    
WORKDIR /root

# set up ros workspace
RUN mkdir ./mrg_ws \
    && mkdir ./mrg_ws/src

# configure desktop file
# make user desktop directory
RUN mkdir -p /root/Desktop/

# fix desktop permissions issue
RUN sed -i 's@Exec=/usr/bin/caja@Exec=/usr/bin/caja --force-desktop@g' /usr/share/applications/caja.desktop

# set up bashrc
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc \
    && echo "source /opt/ros_gz_ws/install/setup.bash" >> /root/.bashrc \
    && echo "cd ~/mrg_ws; source ./install/setup.bash;" >> /root/.bashrc \
    && echo "cd ~/mrg_ws;" >> /root/.bashrc
