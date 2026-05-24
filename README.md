Usei o modelo do Iago como base
https://github.com/iago-silvestre/search-rescue-px4
Mas tirei várias coisas, como as pessoas no mar.

#Também inseri um modelo de plataforma móvel
https://github.com/PX4/PX4-gazebo-models/blob/moving_platform_world/worlds/moving_platform.sdf

## **Introduction**

This project demonstrates the use of **Jason BDI (Belief-Desire-Intention) agents** to control **Unmanned Aerial Vehicles (UAVs)** in a **PX4 SITL (Software In The Loop)** search and rescue simulation. The goal is to showcase the application of **BDI cognitive architectures** in autonomous UAV systems, focusing on their ability to plan and execute search and rescue missions in simulated environments.

---


## **Installation Setup (With Docker)**

You can run this setup using Docker. For [Windows](https://docs.docker.com/desktop/setup/install/windows-install/) it is recommended to have [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) installed.

Abrir XLaunch, multiple windows > start no client > disable acess control > finish
Abrir docker e esperar estar com engine running.

1. **Clone the repository**:
   ```bash
   git clone https://github.com/natereza/moving_plataform_gazebo.git
   cd moving_plataform_gazebo
   ```

3. **Build the Docker image**:
4. ```bash
   docker build -t moving-test .
   ```

This command builds the Docker image for this project. The first build may take a long time (20–60 minutes), because it installs ROS Noetic, PX4 SITL, Gazebo, and compiles all dependencies.

3. **Verify the image was built**:
   ```bash
   docker images
   ```

You should see an image named moving-test.


### **For Windows Users (with VCXsrv)**

1. **Install VCXsrv** from [here](https://github.com/marchaesen/vcxsrv) and start it with XLaunch using default settings.
   
2. **Set the DISPLAY environment**:
Set the `DISPLAY` to point to the host machine’s X11 server:
     ```bash
     set DISPLAY=host.docker.internal:0
     ```

3. **Run the container**:
   ```bash
   docker run -it --rm --name moving_container --env DISPLAY=host.docker.internal:0 --volume /tmp/.X11-unix:/tmp/.X11-unix --env QT_X11_NO_MITSHM=1 --net host moving-test
   ```

   You could add another volume if you're working on agents source code on your host machine, just add the following in the docker run command mentioned above:
   ```bash
   --volume /path/on/host:/path/in/container
   ```
---


### **Tips for Docker**
You can open another terminal in the docker image by joining the same container, first check which containers are running:

**Abrir outro terminal dentro do container**:
   ```bash
   docker exec -it moving_container bash
   ```

**Lista de tópicos**:
   ```bash
   rostopic list
   ```
   ```bash
      rostopic list | grep moving
   ```
Then you can join your container on a new terminal by entering, make sure to replace container_name to your own:

2. **Open a new terminal in the container**:
   ```bash
   docker exec -ti container_name bash
   ```
   

---


## **How to Use the Setup**
Start by running the Gazebo Simulation and spawning the PX4 UAVs
```bash
roslaunch moving_plataform_gazebo multi_uav_mavros_sitl.launch
```
This should open a ROS-Gazebo simulation of 3 UAVs in a rescue scenario. From there you can control these UAVs with MAVROS topics and services such as
```bash
rosservice call /uav0/mavros/cmd/arming 1
```
This arms the motors of uav0, and you should see in the same terminal the response
```bash
success: True
result: 0
```
*(More Instructions to be filled in later)*

---



## **Acknowledgments**

- **PX4-Autopilot**: Open-source flight control software for UAVs.
- **ROS**: The Robot Operating System (ROS) provides the framework for controlling and simulating the UAV.
- **Jason BDI**: A framework for implementing BDI (Belief-Desire-Intention) agent-based systems.
- **Gazebo**: A simulation platform for testing robots in realistic environments.

