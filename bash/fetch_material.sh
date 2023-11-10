#!/bin/bash
# sq2h
SCRIPTDIR=/home/quagadmin/courses/lbgfs2023/bash
#DIRTOFETCH=ex/lbg_ex09
DIRTOFETCH=sol/lbg_ex08
TESTSTUDENT=/home/quagadmin/courses/lbgfs2023/students/test_usernames_lbgfs_2023.csv
STUDENTUSER=/home/quagadmin/courses/lbgfs2023/students/usernames_lbgfs_2023.csv
#' fetch individual directory
#' change to progdir
cd $SCRIPTDIR

#' fetch for test student
cat $TESTSTUDENT | while read s
do
  echo " * Student: $s"
  ./fetch.sh -s $s -d $DIRTOFETCH
  sleep 2
done

#' fetch for real students
cat $STUDENTUSER | while read s
do
  echo " * Student: $s"
  ./fetch.sh -s $s -d $DIRTOFETCH
  sleep 2
done

# check content
cat $STUDENTUSER | while read s
do
  echo " * Student: $s"
  ls -l /home/quagadmin/courses/lbgfs2023/home/$s/lbgfs2023/$DIRTOFETCH
  sleep 2
done
