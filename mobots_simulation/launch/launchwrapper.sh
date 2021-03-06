#!/bin/sh
export OGRE_RTT_MODE=Copy #bug workaround
trap "killall python; killall image_view; killall gazebo;" INT HUP TERM 
roscore &
sleep 2
rosrun image_view image_view image:=/my_cam/image &
xterm -e rosrun erratic_teleop erratic_keyboard_teleop &
rosrun mobots_simulation mobots_teleop_bridge &
rosparam load $(rospack find mobots_simulation)/models/gazebo_camera.urdf test_cam
roslaunch mobots_simulation streetmap.launch &
gazebo_pid=$(echo $!)
sleep 2
rosrun gazebo spawn_model -param test_cam -urdf -model mobot -z 3 #-P 75 -Y 90 -R 50
wait $gazebo_pid
