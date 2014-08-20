ros_eclipse_project_generator
=============================

Creates eclipse projects for ROS catkin packages

Set links to scripts:
=
```bash
sudo ln -s ~/git/ros_eclipse_project_generator/catkin-eclipse-project.sh /bin/catkin-eclipse-project
sudo ln -s ~/git/ros_eclipse_project_generator/eclipsemake /bin/eclipsemake
sudo ln -s ~/git/ros_eclipse_project_generator/eclipsemake-test /bin/eclipsemake-test
```

How to add an catkin project:
=
```bash
roscd my_package
catkin-eclipse-project -i
```

Command line options
=
`-i`

 imports the package to eclipse (using ~/workspace as eclipse workspace)
 
`-p project_name`

 sets the project name, otherwise the current folder name is proposed
 
`-s path`

 sets the project source directory, otherwise the current directory is taken
