#!/bin/bash
#
############
# VARIABLES
############
DEBUG="false"
SCRIPTNAME="daily-cleanup"
source /etc/grab-bag.conf


############
# CLEAR HIGH RESOLUTION PICTURES FROM HIRESDAYS DAYS AGO
############
LASTWEEK=`date --date="$HIRESDAYS days ago" +%Y/%m/%d`
if [ "$DEBUG" == "true" ] ; then
  echo "lastweek: $LASTWEEK  hiresdays: $HIRESDAYS"
  ls -d $DATADIR/$LASTWEEK
fi
if [ -d $DATADIR/$LASTWEEK ] ; then
	rm -rf $DATADIR/$LASTWEEK/*/high
fi

############
# CLEAR LOCAL DAY FROM LOCALKEEPDAYS DAYS AGO
############
MONTHSAGO=`date --date="$LOCALKEEPDAYS days ago" +%Y/%m/%d`
if [ "$DEBUG" == "true" ] ; then
  echo "monthsago: $MONTHSAGO  localkeepdays: $LOCALKEEPDAYS"
  ls -d $DATADIR/$MONTHSAGO
fi
if [ -d $DATADIR/$MONTHSAGO ] ; then
	rm -rf $DATADIR/$MONTHSAGO
fi

############
# CLEAR REMOTE HOURLY VIDEOS (SCP ONLY)
############
REMOTEHOURLYDATE=`date --date="$REMOTEKEEPHOURLY days ago" +%Y/%m/%d`
if [ "$DEBUG" == "true" ] ; then
  echo "REMOTEHOURLYDATE: $REMOTEHOURLYDATE  REMOTEKEEPHOURLY: $REMOTEKEEPHOURLY"
fi
if [ -d $DATADIR/$MONTHSAGO ] ; then
	rm -rf $DATADIR/$MONTHSAGO
fi
if [ "${UPLOADTYPE}" == "scp" ] ; then
  if [ "${SSHAUTH}" == "password" ] ; then
    SSHOPTION=" -p ${UPLOADPASSWORD} "
  elif [ "${SSHAUTH}" == "key" ] ; then
    SSHOPTION=" -i ${SSHKEY} "
  fi
  ssh ${SSHOPTION} ${UPLOADUSER}@${UPLOADSERVER} "rm -f ${UPLOADPATH}/${REMOTEDAILYDATE}/video.hourly*"
fi

############
# CLEAR REMOTE DAILY VIDEOS (SCP ONLY)
############
REMOTEDAILYDATE=`date --date="$REMOTEKEEPDAILY days ago" +%Y/%m/%d`
if [ "$DEBUG" == "true" ] ; then
  echo "REMOTEDAILYDATE: $REMOTEDAILYDATE  REMOTEKEEPDAILY: $REMOTEKEEPDAILY"
fi
if [ -d $DATADIR/$MONTHSAGO ] ; then
	rm -rf $DATADIR/$MONTHSAGO
fi
if [ "${UPLOADTYPE}" == "scp" ] ; then
  if [ "${SSHAUTH}" == "password" ] ; then
    SSHOPTION=" -p ${UPLOADPASSWORD} "
  elif [ "${SSHAUTH}" == "key" ] ; then
    SSHOPTION=" -i ${SSHKEY} "
  fi
  ssh ${SSHOPTION} ${UPLOADUSER}@${UPLOADSERVER} "rm -f ${UPLOADPATH}/${REMOTEDAILYDATE}/*.mp4"
fi


