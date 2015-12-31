#!/bin/bash
#
############
# VARIABLES
############
DEBUG="false"
SCRIPTNAME="grab-pictures"
source /etc/grab-bag.conf
LOCKFILE="$LOCKDIR/$SCRIPTNAME"

############
# Check if we are already running
############
if [ -d $LOCKDIR ] ; then
  if [ -f $LOCKFILE ] ; then
    # We have a lockfile, check if it really is running
    OLDPROCESS=`cat $LOCKFILE`
    if [ -d /proc/$OLDPROCESS ] ; then
      # We are already running
      exit 1
    else
      # Stale lock file, make it fresh and move on
      echo $$ > $LOCKFILE
    fi
  else
    # No lockfile, assume we can run
    echo $$ > $LOCKFILE
  fi
else
  # This is the first time running, set things up
  mkdir $LOCKDIR
  echo $$ > $LOCKFILE
fi

############
# MAIN PROGRAM
############
while true
do
HOUR=`date +%H`
if [ $HOUR -gt $ENDHOUR ]  ; then
  # End of the day, exit
  rm -f $LOCKFILE
  exit 2
elif [ $HOUR -ge $STARTHOUR ] ; then
  # Do each camera separately
  for camera in ${!cameras[@]}
  do
    camera_url=`echo ${cameras["$camera"]}| awk '{print $1}'`
    DATE=`date +%Y%m%d-%H-%M%S`
    THISDAY=`echo $DATE | cut -d'-' -f1`
    THISHOUR=`echo $DATE | cut -d'-' -f2`
    if ! [ -d $DATADIR/$THISDAY/$THISHOUR ] ; then
      mkdir -p $DATADIR/$THISDAY/$THISHOUR/high
    fi
    cd $DATADIR/$THISDAY/$THISHOUR
    if [ "$DEBUG" == "true" ] ; then
      echo "camera: $camera  URL: $camera_url"
      pwd
    fi
    wget -q $camera_url
    sync
    mv -f photo.jpg high/$camera-$DATE.jpg
    sleep $PAUSETIME
  done
else
	# Day has not started yet, sleep for 2 minutes
	sleep 120
fi
done


