#!/bin/bash
#
# This script will setup video-grab-bag by 
#  putting everything in it's default directories

# FORCE
# Set this to -f if you want to force everything on
#FORCE=" -f "
FORCE=""

# VERBOSE
# Set this to -v if you want to see everything move
VERBOSE=" -v "
#VERBOSE=""

# Setup Scripts
cp $VERBOSE $FORCE scripts/* /usr/bin/

# Setup Config
if [ "$FORCE" == "" ] ; then
  if [ -f /etc/grab-bag.conf ] ; then
    cp $VERBOSE $FORCE conf/grab-bag.conf /etc/grab-bag.conf.new
  else
    cp $VERBOSE $FORCE conf/grab-bag.conf /etc/grab-bag.conf
  fi
else
  if [ -f /etc/grab-bag.conf ] ; then
    mv $VERBOSE $FORCE /etc/grab-bag.conf /etc/grab-bag.conf.old
    cp $VERBOSE $FORCE conf/grab-bag.conf /etc/grab-bag.conf
  else
    cp $VERBOSE $FORCE conf/grab-bag.conf /etc/grab-bag.conf
  fi
fi

# Setup Cronjobs
cp $VERBOSE $FORCE cron/* /etc/cron.d/


