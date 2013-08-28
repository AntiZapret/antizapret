#!/bin/bash

function iptables_block_gosnet_start() {
	while read net; do
		iptables -t raw -A PREROUTING -s "$net" -m comment --comment "Блокировка госорганов" -j DROP
	done < list.txt
}

function iptables_block_gosnet_stop() {
	while read net; do
		iptables -t raw -D PREROUTING -s "$net" -m comment --comment "Блокировка госорганов" -j DROP
	done < list.txt
}

case "$1" in
	start)
		iptables_block_gosnet_stop
		iptables_block_gosnet_start
		;;
	stop)
		iptables_block_gosnet_stop
		;;
	restart)
		iptables_block_gosnet_stop
		iptables_block_gosnet_start
		;;
	*)
		echo "Usage: $0 {start|stop|restart}" >&2
		exit 1
		;;
esac

exit 0
