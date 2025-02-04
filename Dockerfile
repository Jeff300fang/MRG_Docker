# set up runtime container
FROM --platform=$TARGETARCH tiryoh/ros2-desktop-vnc:jazzy
ENV ROS_DISTRO=jazzy
ENV GZ_VERSION=harmonic
SHELL ["/bin/bash", "-c"]

# set user to root
USER root
ENV USER=root \
    HOME=/root

# install runtime dependencies, vim, gedit, and xacro
# removed python3-sdformat14 because gazebo osrf public keys are broken rn, hope we don't need it
RUN apt-get update && apt-get install --no-install-recommends -y \
    libgoogle-glog-dev python3-dev python3-pip python3-numpy vim \
    gedit ros-jazzy-xacro ros-jazzy-rosbridge-suite python-is-python3
RUN pip3 install --break-system-packages transforms3d
    
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
RUN echo "source /opt/ros/jazzy/setup.bash" >> /root/.bashrc \
    && echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> /root/.bashrc \
    && echo "test -f ~/mrg_ws/install/setup.bash && source ~/mrg_ws/install/setup.bash" >> /root/.bashrc \
    && echo "cd ~/mrg_ws;" >> /root/.bashrc
