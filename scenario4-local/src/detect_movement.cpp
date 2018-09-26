#include <iostream>
#include <string>
#include <ros/ros.h>
#include "std_msgs/String.h"
#include <control_msgs/JointTrajectoryControllerState.h>
double min_bound_pan = 1.30;
double max_bound_pan = 1.70;
double min_bound_tilt = -0.5;
double max_bound_tilt = 0.0;
double min_bound_elbow = -0.5;
double max_bound_elbow = 1.5;

using namespace std;

string answer = "";
string flag = "Well done! Here's your password: L:+)[RW6P^EFk2[J";

void positionCallback(const control_msgs::JointTrajectoryControllerState::ConstPtr& msg) {
    double pan = msg->actual.positions[0];
    double tilt = msg->actual.positions[1];
    double elbow = msg->actual.positions[2];
    if (((pan > min_bound_pan) && (pan < max_bound_pan))
        && ((tilt > min_bound_tilt) && (tilt < max_bound_tilt))
        && ((elbow > min_bound_elbow) && (elbow < max_bound_elbow))) {
            answer = flag;
        }
    }

int main(int argc, char **argv) {

  ros::init(argc, argv, "node_rctf");
  ros::NodeHandle n;
  ros::Subscriber sub = n.subscribe("/arm_controller/state", 1000, positionCallback);
  ros::Publisher flag_pub = n.advertise<std_msgs::String>("flag", 1000);
  ros::Rate loop_rate(10);
  while (ros::ok()){
    std_msgs::String msg;
    stringstream ss;
    ss << answer;
    msg.data = ss.str();
    flag_pub.publish(msg);
    ros::spinOnce();
    loop_rate.sleep();
  }
  return 0;
}
