#!/bin/sh
# /etc/init.d/little-nets
# starts up mesh0, bat0 interfaces

#TODO move app to /usr/bin/
DAEMON=sudo
NAME=little-nets
DESC="Sets up BATMAN ADV mesh node"
PIDFILE=/var/run/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME

	case "$1" in
		start)
			echo "Starting $NAME mesh point..."
			# delete default interfaces
			$DAEMON ifconfig wlan0 down
			$DAEMON iw dev wlan0 del

			# create the mesh0 interfaces
			$DAEMON iw phy phy0 interface add mesh0 type adhoc
			$DAEMON ifconfig mesh0 mtu 1532
			$DAEMON iwconfig mesh0 mode ad-hoc essid houseFM ap 02:12:34:56:78:90 channel 3
			$DAEMON ifconfig mesh0 down

			# add the interface to batman
			$DAEMON batctl if add mesh0
			$DAEMON batctl ap_isolation 1

			# bring up the BATMAN adv interface
			$DAEMON ifconfig mesh0 up
			$DAEMON ifconfig bat0 192.168.90.4
			$DAEMON ifconfig bat0 up
			sleep 20
			pd-extended -nogui /home/ccrma/little-nets/off-the-grid/pd/Pi_1/Master.pd &
			;;
		status)
		;;
		stop)
		;;

		restart)
			$0 stop
			$0 start
		;;

*)
		echo "Usage: $0 {status|start|stop|restart}"
		exit 1
esac
