#!/bin/bash
###
###
###
###   Purpose:   Shell scripts to fetch new material from github
###   started:   2018/03/11 (pvr)
###
### ##################################################### ###

#Set Script Name variable
SCRIPT=`basename ${BASH_SOURCE[0]}`
echo " *** Start fetching with $SCRIPT ..."

### # define a few constants
BRANCH=rexpf
PROJDIR=lbgfs2022
PROJROOT=/home/quagadmin/courses/${PROJDIR}
GITHUBURL=https://github.com/charlotte-ngs/${PROJDIR}.git
ADMIN=`whoami`
CURWD=/home/${ADMIN}
echo " *** * Project dir: $PROJDIR"
echo " *** * Current working dir: $CURWD"
echo " *** * Branch: $BRANCH"
echo " *** * GITHUB: $GITHUBURL"

### # functions
usage () {
  local l_MSG=$1
  echo "Usage Error: $l_MSG"
  echo "Usage: $SCRIPT -s <user_string> -d <dir_string>"
  echo "  where <user_string> specifies username of the student"
  echo "  where <dir_string> specifies the name of the directory to be fetched"
  exit 1
}

fetch () {
  local l_FETCHDIR=$1
  local l_STUDENT=$2
  local l_PROJPATH=$3
  echo " *** Fetch material for student: $l_STUDENT into home dir: $l_HOME"
  cd $l_PROJPATH
  sudo git fetch
  sudo git checkout origin/$BRANCH ${l_FETCHDIR}
  sudo chown -R quagadmin: .
}

### Start getopts code ###
#Parse command line flags
#If an option should be followed by an argument, it should be followed by a ":".
#Notice there is no ":" after "h". The leading ":" suppresses error messages from
#getopts. This is required to get my unrecognized option code to work.
while getopts :s:d: FLAG; do
  case $FLAG in
    s) # set option "s"
    STUDENT=$OPTARG
    PROJPATH=${PROJROOT}/home/${STUDENT}/${PROJDIR}
    [ -d "${PROJPATH}" ] || usage "Cannot find student project path: $PROJPATH"
	  ;;
	  d) # setting option "d"
	  FETCHDIR=$OPTARG
	  ;;
    *) # invalid command line arguments
	  usage "Invalid command line argument $OPTARG"
	  ;;
  esac
done

### # cloning
fetch $FETCHDIR $STUDENT $PROJPATH

cd $CURWD
echo "fetching of dir: $FETCHDIR for $STUDENT into $PROJPATH done"

