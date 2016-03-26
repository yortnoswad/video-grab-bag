#!/bin/bash
#
############
# VARIABLES
############
DEBUG="false"
SCRIPTNAME="make-movie-hourly"
source /etc/grab-bag.conf
DATE=`date --date="yesterday" +%Y%m%d-%H-%M%S`
THISDAY=`date --date="yesterday" +%Y/%m/%d`
THISDAYDASH=`date --date="yesterday" +%Y-%m-%d`

if [ "$DEBUG" == "true" ] ; then
  echo "date: $DATE  thisday: $THISDAY thisdaydash: $THISDAYDASH"
  ls -d $DATADIR/$THISDAY
fi

############
# MAIN PROGRAM
############
if [ -d $DATADIR/$THISDAY ] ; then
  if ! [ -d $DATADIR/$THISDAY/video ] ; then
    mkdir -p $DATADIR/$THISDAY/video
    cd $DATADIR/$THISDAY/video

    for camera in ${!cameras[@]}
    do
      if [ "$DEBUG" == "true" ] ; then
        echo "camera: $camera"
      fi
    
      export count=1
      ls -1 ../*/low/$camera* | while read line; do if [ $count -lt 10 ] ; then cp $line 000$count.photo$camera.jpg; elif [ $count -lt 100 ] ; then cp $line 00$count.photo$camera.jpg; elif [ $count -lt 1000 ] ; then cp $line 0$count.photo$camera.jpg; else cp $line $count.photo$camera.jpg; fi; let count=$count+1; done
      ffmpeg -r 25 -i %04d.photo$camera.jpg video.$THISDAYDASH.$camera.mp4 > /dev/null 2>&1
      ln video.$THISDAYDASH.$camera.mp4 ../
      
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
# if [ -d $DATADIR/$YESTERDAY ] ; then
# 	cd $DATADIR/$YESTERDAY
#lftp -e "cd daily/$YESTERDAYYEAR/$YESTERDAYMONTH; put video.$YESTERDAY.1.mp4; put video.$YESTERDAY.2.mp4; bye" -u $UPLOADUSER,$UPLOADPASSWORD $UPLOADSERVER
# fi
# 
