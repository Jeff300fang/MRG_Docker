# Base image with ROS 2 Jazzy and VNC desktop
FROM --platform=$TARGETARCH tiryoh/ros2-desktop-vnc:jazzy
ENV ROS_DISTRO=jazzy
ENV GZ_VERSION=harmonic
SHELL ["/bin/bash", "-c"]

# set user to root
USER root
ENV USER=root \
    HOME=/root

# Install dependencies (including tmux/tmuxp here)
RUN apt-get update && apt-get install --no-install-recommends -y \
    libgoogle-glog-dev python3-dev python3-pip vim gedit \
    ros-jazzy-xacro ros-jazzy-rosbridge-suite python-is-python3 \
    tmux tmuxp wget gnupg lsb-release \
 && rm -rf /var/lib/apt/lists/*

# Fix Gazebo OSRF key issue + install python3-sdformat14
RUN wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/gazebo-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/gazebo-archive-keyring.gpg] \
       http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" \
       > /etc/apt/sources.list.d/gazebo-stable.list \
    && apt-get update \
    && apt-get remove -y '*sdformat*' || true \
    && apt-get install -y gz-harmonic ros-jazzy-ros-gz python3-sdformat14 \
    && rm -rf /var/lib/apt/lists/*

# Python packages
RUN pip3 install --break-system-packages transforms3d \
    && pip3 install --break-system-packages numpy==1.26.1

# set up ros workspace
WORKDIR /root
RUN mkdir ./mrg_ws && mkdir ./mrg_ws/src

# configure desktop file
RUN mkdir -p /root/Desktop/ \
    && sed -i 's@Exec=/usr/bin/caja@Exec=/usr/bin/caja --force-desktop@g' /usr/share/applications/caja.desktop

# set up bashrc
RUN echo "source /opt/ros/jazzy/setup.bash" >> /root/.bashrc \
    && echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> /root/.bashrc \
    && echo "test -f ~/mrg_ws/install/setup.bash && source ~/mrg_ws/install/setup.bash" >> /root/.bashrc \
    && echo "cd ~/mrg_ws;" >> /root/.bashrc

# Create a directory for tmuxp projects
RUN mkdir -p /root/.tmuxp

# Copy tmux configs
COPY tmuxp_config.yaml /root/.tmuxp/tmuxp_config.yaml
COPY .tmux.conf /root/.tmux.conf

