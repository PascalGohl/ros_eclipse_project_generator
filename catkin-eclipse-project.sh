#!/bin/sh
#
# Imports a project into Eclipse from the command line.
#
# Based on scritp from http://lugendal.wordpress.com/2009/07/22/eclipse-ctd-new-project-fast
#
# Usage: eclipse-import.sh [ -s path-to-source-dir ] [ -p project-name ] [ -i ]
#
# Just simply pass the directory of the source code you want to import to Eclipse.
# If you don't pass anything then the current working directory is imported.
#
# This script will ask you what name you want to give to the project if you don't 
# specify anything in the command line.
#
# -i will import the new project into eclipse
#
# Dependencies: zenity
#
# BUGS: 2009.07.22: Eclipse cannot be running while during the operation of this script.
# This is an issue with Eclipse 3.5 (Galileo).
#
 
ECLIPSE_PATH=eclipse
WORKSPACES_DIR=~/workspace

# Find script location following all links
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
TEMPLATES_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )" # This contains the template .project and .cproject files.
 
TEMP_FILE=/tmp/asdf1234edd.txt
 
get_script_path() {
    cd `dirname $1` > /dev/null
    DIR=`pwd`
    cd - > /dev/null
    echo $DIR
}
 
THIS_DIR=`get_script_path $0`

while getopts "s:p:i" flag
do
    case $flag in
        s)
            SRC_DIR=$OPTARG
            ;;
        p)
            PROJ_NAME=$OPTARG
            ;;
        i)
            IMPORT=1
            ;;
        *)
            echo "Unrecognized argument '$flag'!"
            exit 1
            ;;
    esac
done
  
#
# BUG: 2009.07.22: Eclipse cannot be running when we import a project.
# Otherwise the import gets lost.
#
if [ $IMPORT ]; then
  if ps ax | grep eclipse | grep -v grep | grep -v $0 > /dev/null; then
      zenity --title='Error' --error --text="Eclipse is running! Please exit Eclipse!"
      exit 1
  fi
fi

[ -z $SRC_DIR ] && SRC_DIR=./
# Get absolute path of SRC_DIR
cd $SRC_DIR
SRC_DIR=`pwd`
cd - > /dev/null
 
if [ ! -d "$SRC_DIR" ]; then
    zenity --title='Error' --error --text="$SRC_DIR is not a directory or it does not exist!"
    exit 1
fi
 
if [ -z $PROJ_NAME ]; then
    PROJ_NAME=`basename $SRC_DIR`
    PROJ_NAME=`zenity --title='Give a name to the project' --entry --text='Project name:' --entry-text="$PROJ_NAME"`
    [ -z $PROJ_NAME ] && exit 0
fi
 
echo src = $SRC_DIR
echo ws = $WS
echo proj_name = $PROJ_NAME
 
cat $TEMPLATES_DIR/.project | sed -e "s/template-name/$PROJ_NAME/g" > $SRC_DIR/.project
cat $TEMPLATES_DIR/.cproject | sed -e "s/template-name/$PROJ_NAME/g" > $SRC_DIR/.cproject

if [ $IMPORT ]; then
  ($ECLIPSE_PATH -nosplash -data $WORKSPACES_DIR \
      -application org.eclipse.cdt.managedbuilder.core.headlessbuild -import "$SRC_DIR" 2>&1 | tee $TEMP_FILE) | \
  zenity --progress --pulsate --auto-close --auto-kill
  OUTPUT=`cat $TEMP_FILE`
  zenity --title='Result' --info --text="$OUTPUT"
  rm -f $TEMP_FILE
fi

