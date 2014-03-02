#!/usr/bin/env sh

LOC="$(dirname ${0})"
. "${LOC}"/common.sh

iptables_ipset_block_gosnet_start() {
	ipset create GOSNET          hash:net
	ipset create GOSNETWHITELIST hash:net

	getwhitelist_v4 |
	while read net; do
		ipset add GOSNETWHITELIST "$net"
	done

	getblacklist_v4 |
	while read net; do
		ipset add GOSNET "$net"
	done

	getwhitelist_v6 |
	while read net; do
		ipset add GOSNETWHITELIST "$net"
	done

	getblacklist_v6 |
	while read net; do
		ipset add GOSNET "$net"
	done

	iptables -t filter -N BLOCKGOSNET
	iptables -t filter -A BLOCKGOSNET -m set --match-set GOSNETWHITELIST src -j RETURN
	iptables -t filter -A BLOCKGOSNET -m set --match-set GOSNET          src -j DROP
	iptables -t filter -I INPUT   -j BLOCKGOSNET
	iptables -t filter -I FORWARD -j BLOCKGOSNET
}

iptables_ipset_block_gosnet_stop() {
	(
		iptables -t filter -D INPUT   -j BLOCKGOSNET
		iptables -t filter -D FORWARD -j BLOCKGOSNET
		iptables -t filter -F BLOCKGOSNET
		iptables -t filter -X BLOCKGOSNET
		ipset destroy GOSNET
		ipset destroy GOSNETWHITELIST
	) 2>/dev/null
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

