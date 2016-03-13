#!/bin/bash
#
############
# VARIABLES
############
DEBUG="false"
SCRIPTNAME="make-movie-hourly"
source /etc/grab-bag.conf
DATE=`date --date="last hour" +%Y%m%d-%H-%M%S`
THISDAY=`echo $DATE | cut -d'-' -f1`
THISHOUR=`echo $DATE | cut -d'-' -f2`

if [ "$DEBUG" == "true" ] ; then
  echo "date: $DATE  thisday: $THISDAY thishour: $THISHOUR"
  ls -d $DATADIR/$THISDAY/$THISHOUR
fi

############
# MAIN PROGRAM
############
if [ -d $DATADIR/$THISDAY/$THISHOUR ] ; then
  if ! [ -d $DATADIR/$THISDAY/$THISHOUR/video ] ; then
    mkdir -p $DATADIR/$THISDAY/$THISHOUR/video
    if ! [ -d $DATADIR/$THISDAY/$THISHOUR/low ] ; then
      mkdir -p $DATADIR/$THISDAY/$THISHOUR/low
    fi
    for camera in ${!cameras[@]}
    do
      camera_orientation=`echo ${cameras["$camera"]}| awk '{print $2}'`
      if [ "$DEBUG" == "true" ] ; then
        echo "camera: $camera  orientation: $camera_orientation"
      fi

      #shrink photos first
      cd $DATADIR/$THISDAY/$THISHOUR/high
      ls -1 $camera-* | while read line
      do
        if [ "$camera_orientation" == "normal" ] ; then
          convert $line -gravity south -pointsize 48 -stroke '#000C' -strokewidth 2 -annotate 0 "$line" -stroke none -fill white  -annotate 0 "$line" -resize 1024x ../low/$line
        else
          convert $line -gravity south -pointsize 48 -stroke '#000C' -strokewidth 2 -annotate 0 "$line" -stroke none -fill white  -annotate 0 "$line" -flip -flop -resize 1024x ../low/$line
        fi
      done
      
      # Now make the movie
      cd $DATADIR/$THISDAY/$THISHOUR/video
      export count=1
      ls -1 ../low/$camera* | while read line; do if [ $count -lt 10 ] ; then cp $line 000$count.photo$camera.jpg; elif [ $count -lt 100 ] ; then cp $line 00$count.photo$camera.jpg; elif [ $count -lt 1000 ] ; then cp $line 0$count.photo$camera.jpg; else cp $line $count.photo$camera.jpg; fi; let count=$count+1; done
      ffmpeg -r $HOURLYFRAMERATE -i %04d.photo$camera.jpg video.$THISDAY-$THISHOUR.$camera.mp4 > /dev/null 2>&1
      ln video.$THISDAY-$THISHOUR.$camera.mp4 ../
      ln video.$THISDAY-$THISHOUR.$camera.mp4 ../../
      # cleanup video directory
      rm -f *.jpg
    done
  fi
fi

############
# Upload video's
# - implement this in a little bit
############
#cd $DATADIR/$THISDAY/$THISHOUR/video
#lftp -e "cd hourly; mkdir $THISDAY; cd $THISDAY; put video.$THISDAY-$THISHOUR.1.mp4; put video.$THISDAY-$THISHOUR.2.mp4; bye" -u $UPLOADUSER,$UPLOADPASSWORD $UPLOADSERVER


