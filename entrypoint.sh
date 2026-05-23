#!/bin/bash
set -e

cd /root/catkin_ws/src/moving_plataform_gazebo

git pull --ff-only || true

sed -i '/search-rescue-px4/d' /root/.bashrc || true
sed -i '/GAZEBO_MODEL_PATH/d' /root/.bashrc || true
sed -i '/GAZEBO_PLUGIN_PATH/d' /root/.bashrc || true

find /root/catkin_ws/src/moving_plataform_gazebo/scripts -type f -name "*.sh" -exec chmod +x {} +

cd /root/catkin_ws
source /opt/ros/noetic/setup.bash
catkin_make
source /root/catkin_ws/devel/setup.bash

source /root/PX4-Autopilot/Tools/simulation/gazebo-classic/setup_gazebo.bash \
  /root/PX4-Autopilot \
  /root/PX4-Autopilot/build/px4_sitl_default

export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:/root/PX4-Autopilot
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:/root/PX4-Autopilot/Tools/simulation/gazebo-classic/sitl_gazebo-classic
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:/root/catkin_ws
export GAZEBO_PLUGIN_PATH=/root/catkin_ws/devel/lib:$GAZEBO_PLUGIN_PATH:/usr/lib/x86_64-linux-gnu/gazebo-11/plugins
export GAZEBO_MODEL_PATH=/root/catkin_ws/src/moving_plataform_gazebo/models:$GAZEBO_MODEL_PATH

cd /root/catkin_ws/src/moving_plataform_gazebo
#!/bin/bash
set -e

cd /root/catkin_ws/src/moving_plataform_gazebo

git pull --ff-only || true

sed -i '/search-rescue-px4/d' /root/.bashrc || true
sed -i '/GAZEBO_MODEL_PATH/d' /root/.bashrc || true
sed -i '/GAZEBO_PLUGIN_PATH/d' /root/.bashrc || true

find /root/catkin_ws/src/moving_plataform_gazebo/scripts -type f -name "*.sh" -exec chmod +x {} +

cd /root/catkin_ws
source /opt/ros/noetic/setup.bash
catkin_make
source /root/catkin_ws/devel/setup.bash

source /root/PX4-Autopilot/Tools/simulation/gazebo-classic/setup_gazebo.bash \
  /root/PX4-Autopilot \
  /root/PX4-Autopilot/build/px4_sitl_default

export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:/root/PX4-Autopilot
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:/root/PX4-Autopilot/Tools/simulation/gazebo-classic/sitl_gazebo-classic
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:/root/catkin_ws
export GAZEBO_PLUGIN_PATH=/root/catkin_ws/devel/lib:$GAZEBO_PLUGIN_PATH:/usr/lib/x86_64-linux-gnu/gazebo-11/plugins
export GAZEBO_MODEL_PATH=/root/catkin_ws/src/moving_plataform_gazebo/models:$GAZEBO_MODEL_PATH

cd /root/catkin_ws/src/moving_plataform_gazebo
exec bash --noprofile --norc
