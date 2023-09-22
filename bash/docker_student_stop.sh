#!/bin/bash
#' ---
#' title: Stop Docker Container
#' date:  2021-03-29 07:12:35
#' author: Peter von Rohr
#' ---
#' ## Purpose
#' Seamless stopping of docker container
#'
#' ## Description
#' Stop running instances of docker container images
#'
#' ## Details
#' This is a wrapper which internally uses the command docker stop
#'
#' ## Example
#' ./docker_student_stop.sh
#'
#' ## Set Directives
#' General behavior of the script is driven by the following settings
#+ bash-env-setting, eval=FALSE
set -o errexit    # exit immediately, if single command exits with non-zero status
set -o nounset    # treat unset variables as errors
set -o pipefail   # return value of pipeline is value of last command to exit with non-zero status
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
  $ECHO "Usage: $SCRIPT  -f <username_input_file>"
  $ECHO "  where -f <username_input_file>  --  specify username or file with list of usernames ..."
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

#' ### Stop docker container from user
#' Given a username, the docker container name is created by
#' appending _rstudio
docker_stop_usr () {
  local l_user_info=$1
  local user=$(echo $l_user_info | cut -d ',' -f1)
  log_msg 'docker_stop_usr' " * Stopping docker instance: ${user}_rstudio ..."
  docker stop ${user}_rstudio

}


#' ### Stop docker container from name
#' Stop docker container image based on container name
docker_stop_name () {
  local l_cnt_name=$1
  log_msg 'docker_stop_name' " * Stopping docker instance: $l_cnt_name ..."
  docker stop $l_cnt_name
}


#' ## Main Body of Script
#' The main body of the script starts here with a start script message.
#+ start-msg, eval=FALSE
start_msg

#' ## Getopts for Commandline Argument Parsing
#' If an option should be followed by an argument, it should be followed by a ":".
#' Notice there is no ":" after "h". The leading ":" suppresses error messages from
#' getopts. This is required to get my unrecognized option code to work.
#+ getopts-parsing, eval=FALSE
USERNAME=""
while getopts ":f:h" FLAG; do
  case $FLAG in
    h)
      usage "Help message for $SCRIPT"
      ;;
    f)
      USERNAME=$OPTARG
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

#' ## Stop Docker Instances
#' If a file was specified, loop over lines and start an instance for each line
#+ docker-stop-inst
if [ -f "$USERNAME" ]
then
  cat $USERNAME | while read e
  do
    log_msg "$SCRIPT" " * Current username: $e ..."
    docker_stop_usr $e
    sleep 2
  done
else
  log_msg "$SCRIPT" " * Current username: $USERNAME ..."
  docker_stop_name $USERNAME
fi

# clean up all instances with status exited
log_msg "$SCRIPT" " * Clean up all instances with status exited ..."
docker rm $(docker ps --filter "status=exited" -q)

#' ## End of Script
#' This is the end of the script with an end-of-script message.
#+ end-msg, eval=FALSE
end_msg

