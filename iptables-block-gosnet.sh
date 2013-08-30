#!/usr/bin/env sh

ACT=""

case "$1" in
	start)
		ACT="A"
		;;
	stop)
		ACT="D"
		;;
	restart)
		"$0" stop &&
		"$0" start || (
			echo "Failed to stop while restarting";
			exit 1
		)
		;;
	*)
		echo "Usage: $0 {start|stop|restart}" >&2
		exit 1
		;;


esac

#TODO: переделать на AWK (?)
	grep -vE '^$|^#' list.txt | while read net; do
		iptables -t raw -${ACT} PREROUTING -s "$net" -m comment --comment "Блокировка госорганов" -j DROP
	done

exit 0
