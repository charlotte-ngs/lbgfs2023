#!/bin/bash
# sq2h
SCRIPTDIR=/home/quagadmin/courses/lbgfs2022/bash
# DIRTOFETCH=ex/lbg_ex10
DIRTOFETCH=sol/lbg_ex10
TESTSTUDENT=/home/quagadmin/courses/lbgfs2022/students/test_student_usernames_lbgfs2022.txt
STUDENTUSER=/home/quagadmin/courses/lbgfs2022/students/student_usernames_lbgfs2022.txt
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
  ls -l /home/quagadmin/courses/lbgfs2022/home/$s/lbgfs2022/$DIRTOFETCH
  sleep 2
done
