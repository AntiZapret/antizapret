#!/usr/bin/env sh

. ./common.sh

case "$1" in
	start)
		iptables -t filter -N BLOCKGOSNET
		iptables -t filter -A BLOCKGOSNET -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
		getblacklist | while read net; do
			iptables -t filter -A BLOCKGOSNET -s "$net" -m comment --comment "Блокировка госорганов" -j DROP
		done
		iptables -t filter -I FORWARD -j BLOCKGOSNET
		iptables -t filter -I INPUT   -j BLOCKGOSNET
		;;
	stop)
		iptables -t filter -D FORWARD -j BLOCKGOSNET
		iptables -t filter -D INPUT   -j BLOCKGOSNET
		iptables -t filter -F BLOCKGOSNET
		iptables -t filter -X BLOCKGOSNET
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

exit 0
