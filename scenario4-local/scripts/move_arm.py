#!/usr/bin/env python
import sys
import copy
import rospy
import moveit_commander
import moveit_msgs.msg
import math
import tf
import geometry_msgs.msg
from random import randint
if __name__ == '__main__':
    rospy.init_node("tf_listener")
    moveit_commander.roscpp_initialize(sys.argv)

    robot = moveit_commander.RobotCommander()

    scene = moveit_commander.PlanningSceneInterface()

    group = moveit_commander.MoveGroupCommander("manipulator")

    listener = tf.TransformListener()

    rate = rospy.Rate(10)
    while not rospy.is_shutdown():
        group.clear_pose_targets()
        try:
            (trans,rot) = listener.lookupTransform('world', 'logical_camera_part3_' + str(randint(1, 9)) + '_frame', rospy.Time(0))
            print(trans, rot)
        except (tf.LookupException, tf.ConnectivityException, tf.ExtrapolationException):
            print("Error")
            continue

        quaternion = (rot[0], rot[1], rot[2], rot[3])
        euler = tf.transformations.euler_from_quaternion(quaternion)
        rot = tf.transformations.quaternion_from_euler(euler[0], euler[1] + 3.14/2, euler[2])

        pose_target = geometry_msgs.msg.Pose()
        pose_target.orientation.x = rot[0]
        pose_target.orientation.y = rot[1]
        pose_target.orientation.z = rot[2]
        pose_target.orientation.w = rot[3]
        pose_target.position.x = trans[0]
        pose_target.position.y = trans[1]
        pose_target.position.z = trans[2] + 0.02
        group.set_pose_target(pose_target)

        plan1 = group.plan()
        group.go(wait=True)
        print(trans, rot)


        rate.sleep()
