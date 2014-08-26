ros_eclipse_project_generator
=============================

Creates eclipse projects for ROS catkin packages

Set links to scripts:
=
```bash
sudo ln -s ~/git/ros_eclipse_project_generator/catkin-eclipse-project.sh /bin/catkin-eclipse-project
sudo ln -s ~/git/ros_eclipse_project_generator/eclipsemake /bin/eclipsemake
sudo ln -s ~/git/ros_eclipse_project_generator/eclipsemake-tests /bin/eclipsemake-tests
```

Preliminary setup (global settings in eclipse)
=
We first need to tweak Eclipse to recognize includes from the compilation commands and to properly recognize C++11 traits (if we are using C++11): Go to Window->Preferences->C/C++->Build->Settings and select the "Discovery" tab. In "CDT GCC Buid Output Parser [ Shared ]" prepend ".*" to the regular expressions, e.g.:
```
(.*gcc)|(.*[gc]\+\+)|(.*clang)
```
This will help Eclipse CDT recognize compiler calls that also contain the path to the compiler. On same page check "Project" for "Container to keep discovered entries". Then, in "CDT GCC Built-in Compiler Settings [ Shared ]" add the "-std=c++11" flag to obtain e.g.:
```
${COMMAND} -E -P -v -dD -std=c++11 "${INPUTS}"
```


How to add an catkin project:
=
```bash
roscd my_package
catkin-eclipse-project -i
```

Command line options
=
 ```bash
-i                   imports the package to eclipse (using ~/workspace as eclipse workspace)

-p project_name      sets the project name, otherwise the current folder name is proposed

-s path              sets the project source directory, otherwise the current directory is used
 ```
 
