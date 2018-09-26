cmake_minimum_required(VERSION 3.5)
project(robotctf_scenario4)

find_package(catkin REQUIRED COMPONENTS roscpp std_msgs control_msgs)
catkin_package()

install(DIRECTORY launch DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION})
install(DIRECTORY world DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION})
install(DIRECTORY urdf DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION})

include_directories(include ${catkin_INCLUDE_DIRS})

add_executable(detect_movement src/detect_movement.cpp)
target_link_libraries(detect_movement ${catkin_LIBRARIES})


install(TARGETS detect_movement RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION})

catkin_install_python(PROGRAMS
  scripts/move_arm.py
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}/scripts
)