#!/bin/bash
#
############
# VARIABLES
############
DEBUG="false"
SCRIPTNAME="grab-pictures"
THREADSCRIPTNAME="grab-pictures-camera"
source /etc/grab-bag.conf
LOGDIR="$DATADIR/logs"

############
# Make sure we have a log directory
############
if ! [ -d ${LOGDIR} ] ; then
  mkdir -p ${LOGDIR}
fi

start() {
  for camera in ${!cameras[@]}
  do
    echo "  Starting camera: ${camera}"
    ${THREADSCRIPTNAME} ${camera} &
  done
  RETVAL=0
}

stop() {
  for camera in ${!cameras[@]}
  do
    echo "  Stopping camera: ${camera}"
    echo "stop" > ${LOCKDIR}/${THREADSCRIPTNAME}.${camera}.stop
  done
  RETVAL=0
}

# See how we were called.
case "$1" in
  start)
	start
	;;
  stop)
	stop
	;;
  status)
        echo "Status not implemented yet"
	RETVAL=3
	;;
  restart)
	stop
        echo "Stop command given.  Waiting for a while before starting"
        sleep $PAUSETIME
        echo "  sleeping 20 more seconds, just to be sure"
        sleep 20
        echo "Starting ..."
	start
	;;
  *)
	echo $"Usage: $prog {start|stop|restart|status}"
esac

exit $RETVAL

