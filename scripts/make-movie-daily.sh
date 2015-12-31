#!/bin/bash
#
############
# VARIABLES
############
DEBUG="false"
SCRIPTNAME="make-movie-hourly"
source /etc/grab-bag.conf
DATE=`date --date="yesterday" +%Y%m%d-%H-%M%S`
THISDAY=`echo $DATE | cut -d'-' -f1`
THISHOUR=`echo $DATE | cut -d'-' -f2`

if [ "$DEBUG" == "true" ] ; then
  echo "date: $DATE  thisday: $THISDAY thishour: $THISHOUR"
  ls -d $BASEDIR/$THISDAY
fi

############
# MAIN PROGRAM
############
if [ -d $BASEDIR/$THISDAY ] ; then
  if ! [ -d $BASEDIR/$THISDAY/video ] ; then
    mkdir -p $BASEDIR/$THISDAY/video
    cd $BASEDIR/$THISDAY/video

    for camera in ${!cameras[@]}
    do
      if [ "$DEBUG" == "true" ] ; then
        echo "camera: $camera"
      fi
    
      export count=1
      ls -1 ../*/low/$camera* | while read line; do if [ $count -lt 10 ] ; then cp $line 000$count.photo$camera.jpg; elif [ $count -lt 100 ] ; then cp $line 00$count.photo$camera.jpg; elif [ $count -lt 1000 ] ; then cp $line 0$count.photo$camera.jpg; else cp $line $count.photo$camera.jpg; fi; let count=$count+1; done
      ffmpeg -r 25 -i %04d.photo$camera.jpg video.$THISDAY.$camera.mp4 > /dev/null 2>&1
      ln video.$THISDAY.$camera.mp4 ../
      
      # Cleanup
      rm -f *.jpg
    done

  fi
fi

############
# UPLOAD YESTERDAYS VIDEOS
# - implement this in a little bit
############
# YESTERDAY=`date --date="yesterday" +%Y%m%d`
# YESTERDAYYEAR=`date --date="yesterday" +%Y`
# YESTERDAYMONTH=`date --date="yesterday" +%m`
# sync
# sync
# if [ -d $BASEDIR/$YESTERDAY ] ; then
# 	cd $BASEDIR/$YESTERDAY
lftp -e "cd daily/$YESTERDAYYEAR/$YESTERDAYMONTH; put video.$YESTERDAY.1.mp4; put video.$YESTERDAY.2.mp4; bye" -u $UPLOADUSER,$UPLOADPASSWORD $UPLOADSERVER
# fi
# 
