#!/bin/bash

Xvfb :1 -screen 0 1024x768x24 &

source /opt/ros/kinetic/setup.bash
export DISPLAY=:1.0
roslaunch robotctf_scenario4 robotctf_scenario4.launch &
cd /root/gzweb
sleep 4
npm start &
sleep 4
rosrun robotctf_scenario4 detect_movement
