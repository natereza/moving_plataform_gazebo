# Use the official PX4 development image with ROS Noetic
FROM iagosilvestre/px4_jason:latest

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F42ED6FBAB17C654

# Set noninteractive mode for apt
#ENV DEBIAN_FRONTEND=noninteractive

# 1. Remove broken shadow-fixed repo BEFORE update
#RUN rm -f /etc/apt/sources.list.d/ros-shadow-fixed.list

# 2. safe to update and install tools
#RUN apt-get update && apt-get install -y curl gnupg2 lsb-release

# 3. Remove expired GPG key (ignore error if it's already gone)
#RUN apt-key del F42ED6FBAB17C654 || true

# 4. Add new ROS GPG key and repo
#RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - && \
#    echo "deb http://packages.ros.org/ros/ubuntu focal main" > /etc/apt/sources.list.d/ros-latest.list

# Create catkin workspace and clone moving_plataform_gazebo
#####teste
RUN rm -rf /root/catkin_ws/src/search-rescue-px4 && \
    rm -rf /root/catkin_ws/src/moving_plataform_gazebo && \
    mkdir -p /root/catkin_ws/src && \
    cd /root/catkin_ws/src && \
    git clone https://github.com/natereza/moving_plataform_gazebo.git

RUN sed -i '/search-rescue-px4/d' /root/.bashrc || true && \
    sed -i '/GAZEBO_MODEL_PATH/d' /root/.bashrc || true && \
    sed -i '/GAZEBO_PLUGIN_PATH/d' /root/.bashrc || true && \
    sed -i '/setup_gazebo.bash/d' /root/.bashrc || true && \
    sed -i '/catkin_ws\/devel\/setup.bash/d' /root/.bashrc || true
#####

#RUN mkdir -p ~/catkin_ws/src && cd ~/catkin_ws/src && \
#    git clone https://github.com/natereza/moving_plataform_gazebo.git

# Build catkin workspace
WORKDIR /root/catkin_ws
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && catkin_make"

# Update bashrc with required environment variables
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc && \
    echo "source /root/catkin_ws/devel/setup.bash" >> ~/.bashrc && \
    echo "source /root/PX4-Autopilot/Tools/simulation/gazebo-classic/setup_gazebo.bash /root/PX4-Autopilot /root/PX4-Autopilot/build/px4_sitl_default" >> ~/.bashrc && \
    echo "export ROS_PACKAGE_PATH=\$ROS_PACKAGE_PATH:/root/PX4-Autopilot" >> ~/.bashrc && \
    echo "export ROS_PACKAGE_PATH=\$ROS_PACKAGE_PATH:/root/PX4-Autopilot/Tools/simulation/gazebo-classic/sitl_gazebo-classic" >> ~/.bashrc && \
    echo "export GAZEBO_PLUGIN_PATH=/root/catkin_ws/devel/lib:\$GAZEBO_PLUGIN_PATH:/usr/lib/x86_64-linux-gnu/gazebo-11/plugins" >> ~/.bashrc && \
    echo "export ROS_PACKAGE_PATH=\$ROS_PACKAGE_PATH:/root/catkin_ws" >> ~/.bashrc && \
    echo "export GAZEBO_MODEL_PATH=/root/catkin_ws/src/moving_plataform_gazebo/models:\$GAZEBO_MODEL_PATH" >> ~/.bashrc

# acabei de descomentar
RUN find /root/catkin_ws/src/moving_plataform_gazebo/scripts -type f -name "*.sh" -exec chmod +x {} +

# Expose the display for GUI-based applications
ENV DISPLAY=:0

# Set working directory and source environment at container startup
WORKDIR /root/catkin_ws/src/moving_plataform_gazebo
# Copy your custom entrypoint script into the container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
