#!/usr/bin/env sh

. ./common.sh

iptables_ipset_block_gosnet_start() {
	ipset create GOSNET hash:net

	getlist list.txt |
	while read net; do
		ipset add GOSNET "$net"
	done

	iptables -t raw -I PREROUTING -m set --match-set GOSNET src -j DROP
}

iptables_ipset_block_gosnet_stop() {
	iptables -t raw -D PREROUTING -m set --match-set GOSNET src -j DROP 2>/dev/null
	ipset destroy GOSNET 2>/dev/null
}

case "$1" in
	start)
		iptables_ipset_block_gosnet_stop
		iptables_ipset_block_gosnet_start
		;;
	stop)
		iptables_ipset_block_gosnet_stop
		;;
	restart)
		iptables_ipset_block_gosnet_stop
		iptables_ipset_block_gosnet_start
		;;
	*)
		echo "Usage: $0 {start|stop|restart}" >&2
		exit 1
		;;
esac

exit 0

