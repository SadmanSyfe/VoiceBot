FROM ubuntu:22.04

RUN mkdir -p /root/ros2_hehe
ADD . /root/ros2_hehe
WORKDIR /root/ros2_hehe
# Set locale
RUN apt-get update && apt-get install -y locales \
&& locale-gen en_US en_US.UTF-8 \
&& update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
&& export LANG=en_US.UTF-8

RUN apt install -y tzdata
RUN ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime \
&& echo "Etc/UTC" > /etc/timezone \
&& dpkg-reconfigure --frontend noninteractive tzdata    
# Install dependencies
RUN apt-get update && apt-get install -y \
curl \
gnupg2 \
lsb-release \
software-properties-common \
tzdata \
git \
python3-pip \
python3-pyaudio 

RUN pip install SpeechRecognition

#Ros2 installation
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN apt-get update

RUN apt-get install -y ros-humble-desktop

# Install TurtleBot 
RUN apt-get install -y ros-humble-gazebo-* \
    ros-humble-cartographer \
    ros-humble-cartographer-ros \
    ros-humble-navigation2 \
    ros-humble-nav2-bringup \
    python3-colcon-common-extensions


RUN colcon build --symlink-install
RUN mkdir -p /root/turtlebot3_ws/src
WORKDIR /root/turtlebot3_ws/src


RUN git clone -b humble https://github.com/ROBOTIS-GIT/DynamixelSDK.git
RUN git clone -b humble https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git
RUN git clone -b humble https://github.com/ROBOTIS-GIT/turtlebot3.git
RUN git clone -b humble https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git

SHELL ["/bin/bash", "-c"]

WORKDIR /root/turtlebot3_ws
RUN source /opt/ros/humble/setup.bash && colcon build --symlink-install

# Add environment variables
RUN echo 'source ~/ros2_hehe/install/setup.bash'
RUN echo 'source /opt/ros/humble/setup.bash' >> ~/.bashrc
RUN echo 'source /root/turtlebot3_ws/install/setup.bash' >> ~/.bashrc
RUN echo 'export ROS_DOMAIN_ID=30' >> ~/.bashrc
RUN echo 'source /usr/share/gazebo/setup.sh' >> ~/.bashrc
RUN echo 'export TURTLEBOT3_MODEL=burger' >> ~/.bashrc

# Uncomment if you want GUI Start

# RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y lubuntu-desktop lightdm xterm

# RUN rm /run/reboot-required*
# RUN echo "/usr/sbin/lightdm" > /etc/X11/default-display-manager
# RUN echo "\
# [LightDM]\n\
# [Seat:*]\n\
# type=xremote\n\
# xserver-hostname=host.docker.internal\n\
# xserver-display-number=0\n\
# autologin-user=root\n\
# autologin-user-timeout=0\n\
# autologin-session=Lubuntu\n\
# " > /etc/lightdm/lightdm.conf.d/lightdm.conf

# ENV DISPLAY=host.docker.internal:0.0

# CMD sh -c "service dbus start && service lightdm start && /bin/bash"
# CMD service dbus start ; service lightdm start

# Uncomment if you want GUI end

# Comment this if you want gui
CMD ["/bin/bash"]
