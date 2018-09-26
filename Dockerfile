FROM gazebo:libgazebo9-xenial

MAINTAINER Lander Usategui <lander@aliasrobotics.com>

# setup keys
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list

EXPOSE 8080

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    libassimp-dev \
    python-rosdep \
    python-rosinstall \
    python-vcstools \
    python-pyassimp \
    ros-kinetic-robot ros-kinetic-perception \
    ros-kinetic-control-toolbox \
    ros-kinetic-controller-manager\
    ros-kinetic-transmission-interface\
    ros-kinetic-joint-limits-interface\
    ros-kinetic-moveit\
    ros-kinetic-joint-state-controller\
    ros-kinetic-position-controllers \
    ros-kinetic-joint-trajectory-controller \
    ros-kinetic-trac-ik* \
    ros-kinetic-gazebo9* \
    xvfb  \ 
    libjansson-dev imagemagick \
    && rm -rf /var/lib/apt/lists/*
#Download the necessary nodjs and npm version
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash -
RUN apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

# bootstrap rosdep
RUN rosdep init \
    && rosdep update

# install ros packages
ENV ROS_DISTRO kinetic

RUN /bin/bash -c "mkdir -p /root/ros_catkin_ws/src && cd /root/ros_catkin_ws/src \
	&& git clone https://github.com/ros-industrial/universal_robot  \
  && cd /root/ros_catkin_ws/ \
  && source /opt/ros/kinetic/setup.bash \
  && catkin_make_isolated --install --install-space /opt/ros/kinetic \
  && cd && rm -r /root/ros_catkin_ws"

RUN /bin/bash -c "cd /root \
                  && hg clone https://bitbucket.org/osrf/gzweb"

RUN /bin/bash -c "cd /root/gzweb && hg up gzweb_1.4.0 \
                  && source /usr/share/gazebo/setup.sh \
                  && npm run deploy \
                  && rm -r /root/gzweb/http/client/assets \
                  && ln -s /root/.gazebo/models/ /root/gzweb/http/client/assets"

RUN sed -i 's/kdl_kinematics_plugin/trac_ik_kinematics_plugin/g' /opt/ros/kinetic/share/ur10_moveit_config/config/kinematics.yaml \
 && sed -i 's/KDLKinematicsPlugin/TRAC_IKKinematicsPlugin/g' /opt/ros/kinetic/share/ur10_moveit_config/config/kinematics.yaml \
 && sed -i 's/load_robot_description\" default=\"false\"/load_robot_description\" default=\"true\"/g' /opt/ros/kinetic/share/ur10_moveit_config/launch/planning_context.launch \
 && sed -i 's/ur_description/robotctf_scenario4/g'  /opt/ros/kinetic/share/ur10_moveit_config/launch/planning_context.launch \
 && sed -i 's/ur10_robot.urdf.xacro/robot_description_original.urdf.xacro/g' /opt/ros/kinetic/share/ur10_moveit_config/launch/planning_context.launch

COPY scenario4-local /root/ros_catkin_ws/src/scenario4
COPY ariac_utils/ /root/ros_catkin_ws/src/ariac_utils

RUN /bin/bash -c "mkdir -p /root/.gazebo/models/ && cp -r /root/ros_catkin_ws/src/scenario4/models/* /root/.gazebo/models/"

RUN /bin/bash -c "cd /root/ros_catkin_ws \
  && source /opt/ros/kinetic/setup.bash \
  && catkin_make_isolated --install --install-space /opt/ros/kinetic \
  && cd && rm -r /root/ros_catkin_ws"

RUN rm -rf /etc/update-motd.d/* && rm -rf /etc/legal && sed -i 's/\#force_color_prompt=yes/force_color_prompt=yes/' /root/.bashrc \
   && sed -i 's/robotctf_scenario1/robotctf_scenario4/g' /opt/ros/kinetic/share/ur10_moveit_config/launch/planning_context.launch

COPY motd /etc/motd

RUN echo "cat /etc/motd" >> /root/.bashrc && echo "source /opt/ros/kinetic/setup.bash" >> /root/.bashrc

COPY launch_script.bash /root/

ENTRYPOINT ["/root/launch_script.bash"]
