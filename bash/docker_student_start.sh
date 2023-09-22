#!/bin/bash
#' ---
#' title: Docker Container Start Script
#' date:  2021-02-28 15:11:54
#' author: Peter von Rohr
#' ---
#' ## Purpose
#' Start script for docker container
#'
#' ## Description
#' Seamless start of docker container for students
#'
#' ## Details
#' This start script requires an input file of usernames to start multiple instances of docker containers
#'
#' ## Example
#' ./docker_student_start.sh -f <username_input_file>
#'
#' ## Set Directives
#' General behavior of the script is driven by the following settings
#+ bash-env-setting, eval=FALSE
set -o errexit    # exit immediately, if single command exits with non-zero status
set -o nounset    # treat unset variables as errors
#set -o pipefail   # return value of pipeline is value of last command to exit with non-zero status
                  #  hence pipe fails if one command in pipe fails


#' ## Global Constants
#' ### Paths to shell tools
#+ shell-tools, eval=FALSE
ECHO=/bin/echo                             # PATH to echo                            #
DATE=/bin/date                             # PATH to date                            #
MKDIR=/bin/mkdir                           # PATH to mkdir                           #
BASENAME=/usr/bin/basename                 # PATH to basename function               #
DIRNAME=/usr/bin/dirname                   # PATH to dirname function                #

#' ### Directories
#' Installation directory of this script
#+ script-directories, eval=FALSE
INSTALLDIR=`$DIRNAME ${BASH_SOURCE[0]}`    # installation dir of bashtools on host   #

#' ### Files
#' This section stores the name of this script and the
#' hostname in a variable. Both variables are important for logfiles to be able to
#' trace back which output was produced by which script and on which server.
#+ script-files, eval=FALSE
SCRIPT=`$BASENAME ${BASH_SOURCE[0]}`       # Set Script Name variable                #
SERVER=`hostname`                          # put hostname of server in variable      #



#' ## Functions
#' The following definitions of general purpose functions are local to this script.
#'
#' ### Usage Message
#' Usage message giving help on how to use the script.
#+ usg-msg-fun, eval=FALSE
usage () {
  local l_MSG=$1
  $ECHO "Usage Error: $l_MSG"
  $ECHO "Usage: $SCRIPT -c <course_home> -d <dry_run> -f <username_input_file> -i <docker_image> -w <pass_dir>"
  $ECHO "  where -f <username_input_file>  --  specify username or file with list of usernames ..."
  $ECHO "        -d                        --  run script in dry-run mode w/out starting container"
  $ECHO "        -c <course_home>          --  directory where course home directories are"
  $ECHO "        -w <pass_dir>             --  directory with existing passwords"
  $ECHO "        -i <docker_image>         --  docker image"
  $ECHO ""
  exit 1
}

#' ### Start Message
#' The following function produces a start message showing the time
#' when the script started and on which server it was started.
#+ start-msg-fun, eval=FALSE
start_msg () {
  $ECHO "********************************************************************************"
  $ECHO "Starting $SCRIPT at: "`$DATE +"%Y-%m-%d %H:%M:%S"`
  $ECHO "Server:  $SERVER"
  $ECHO
}

#' ### End Message
#' This function produces a message denoting the end of the script including
#' the time when the script ended. This is important to check whether a script
#' did run successfully to its end.
#+ end-msg-fun, eval=FALSE
end_msg () {
  $ECHO
  $ECHO "End of $SCRIPT at: "`$DATE +"%Y-%m-%d %H:%M:%S"`
  $ECHO "********************************************************************************"
}

#' ### Log Message
#' Log messages formatted similarly to log4r are produced.
#+ log-msg-fun, eval=FALSE
log_msg () {
  local l_CALLER=$1
  local l_MSG=$2
  local l_RIGHTNOW=`$DATE +"%Y%m%d%H%M%S"`
  $ECHO "[${l_RIGHTNOW} -- ${l_CALLER}] $l_MSG"
}

#' ### Docker Start Function
#' Docker instance start for a given username
#+ docker-start-fun
docker_start () {
  local l_user_info=$1
  log_msg docker_start " * User info: $l_user_info ..."
  local user=$(echo $l_user_info | cut -d ',' -f5)
  local email=$(echo $l_user_info | cut -d ',' -f4)
  local name=$(echo $l_user_info | cut -d ',' -f1)
  local firstname=$(echo $l_user_info | cut -d ',' -f2)
  local l_PORT=$(echo $l_user_info | cut -d ',' -f6)
  if [ ! -f "$PASSDIR/.${user}.pwd" ]
  then
    tr -dc A-Za-z0-9_ < /dev/urandom | head -c8 > $PASSDIR/.${user}.pwd
  fi
  # check whether user home exists
  local l_USERHOME=$COURSEHOME/${user}
  if [[ ! -d $l_USERHOME ]]; then
    log_msg docker_start " * Create user home dir: $l_USERHOME ..."
    mkdir -p $l_USERHOME
  fi
  # take password from file
  local pass=$(cat "$PASSDIR/.${user}.pwd")
  # check whether docker container image is already running
  if [ $(docker ps -a | grep "${user}_rstudio" | wc -l) -eq 0 ]
  then
    local dcmd="docker run -d -p $l_PORT:8787 -e PASSWORD=$pass -v ${l_USERHOME}:/home/rstudio --name ${user}_rstudio $DOCKERIMAGE"
    echo $dcmd
    if [ "$DRYRUN" != "TRUE" ]
    then
      docker run -d -p $l_PORT:8787 -e PASSWORD=$pass -v ${l_USERHOME}:/home/rstudio --name ${user}_rstudio $DOCKERIMAGE
      sudo chmod -R 777 ${l_USERHOME}
      # firewall
      # if [ `sudo ufw status | grep "$l_PORT/tcp" | grep ALLOW | wc -l` -eq 0 ]
      # then
      #   sudo ufw allow $l_PORT/tcp
      # fi
    fi
    printf "To: $email \nSubject: Exercise Platform \n\nDear $firstname $name \nThis e-mail contains the required information for the exercise platform. \n\nPassword: $pass \n\nBest regards, Peter" > ${user}_email.txt
  else
    echo " * Docker container image for ${user} is already running ..."
  fi
}

#' ## Main Body of Script
#' The main body of the script starts here.
#+ start-msg, eval=FALSE
start_msg

#' ## Getopts for Commandline Argument Parsing
#' If an option should be followed by an argument, it should be followed by a ":".
#' Notice there is no ":" after "h". The leading ":" suppresses error messages from
#' getopts. This is required to get my unrecognized option code to work.
#+ getopts-parsing, eval=FALSE
PASSDIR="."
USERNAME=""
COURSEHOME=""
COURSEROOT=$(dirname $INSTALLDIR)
DRYRUN='FALSE'
DOCKERIMAGE='lbgfs2023'
while getopts ":c:df:i:w:h" FLAG; do
  case $FLAG in
    h)
      usage "Help message for $SCRIPT"
      ;;
    c)
      COURSEHOME=$OPTARG
      ;;
    d)
      DRYRUN='TRUE'
      ;;
    f)
      USERNAME=$OPTARG
      ;;
    i)
      DOCKERIMAGE=$OPTARG
      ;;
    w)
      PASSDIR=$OPTARG
      ;;
    :)
      usage "-$OPTARG requires an argument"
      ;;
    ?)
      usage "Invalid command line argument (-$OPTARG) found"
      ;;
  esac
done

shift $((OPTIND-1))  #This tells getopts to move on to the next argument.

#' ## Check Arguments
#' Check that required args are specified
if [[ $DOCKERIMAGE == '' ]];then
  usage " *** ERROR: -i <docker_image> required but undefined ..."
fi


#' ## Defaults Depending on Input
#' The course home directory is created here, if it does not exist
#+ course-home
if [[ $COURSEHOME == '' ]];then
  COURSEHOME=$COURSEROOT/home
fi

#' ## Start Docker Instances
#' If a file was specified, loop over lines and start an instance for each line
#+ docker-start-inst
if [ -f "$USERNAME" ]
then
  cat $USERNAME | while read e
  do
    log_msg "$SCRIPT" " * Current username: $e ..."
    docker_start "$e"
    sleep 2
  done
else
  docker_start "$USERNAME"
fi


#' ## End of Script
#+ end-msg, eval=FALSE
end_msg

