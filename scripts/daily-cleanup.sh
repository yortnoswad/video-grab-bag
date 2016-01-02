#!/bin/bash
#
############
# VARIABLES
############
DEBUG="false"
SCRIPTNAME="daily-cleanup"
source /etc/grab-bag.conf


############
# CLEANOUT LAST WEEKS HIGH RESOLUTION PICTURES
############
LASTWEEK=`date --date="$HIRESDAYS days ago" +%Y%m%d`
if [ "$DEBUG" == "true" ] ; then
  echo "lastweek: $LASTWEEK  hiresdays: $HIRESDAYS"
  ls -d $DATADIR/$LASTWEEK
fi
if [ -d $DATADIR/$LASTWEEK ] ; then
	rm -rf $DATADIR/$LASTWEEK/*/high
fi

############
# CLEAR LOCAL DAY FROM 40 DAYS AGO
############
MONTHSAGO=`date --date="$LOCALKEEPDAYS days ago" +%Y%m%d`
if [ "$DEBUG" == "true" ] ; then
  echo "monthsago: $MONTHSAGO  localkeepdays: $LOCALKEEPDAYS"
  ls -d $DATADIR/$MONTHSAGO
fi
if [ -d $DATADIR/$MONTHSAGO ] ; then
	rm -rf $DATADIR/$MONTHSAGO
fi

