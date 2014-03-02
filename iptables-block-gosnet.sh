#!/usr/bin/env sh

LOC="$(dirname ${0})"
. "${LOC}"/common.sh

case "$1" in
	start)
		# Creating a chain
		iptables -t filter -N BLOCKGOSNET
		iptables -t filter -A BLOCKGOSNET -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

		# Whitelist for IPv4
		getwhitelist_v4 | while read net; do
			iptables -t filter -A BLOCKGOSNET -s "$net" -m comment --comment "Блокировка госорганов" -j RETURN
		done

		# Blacklist for IPv4
		getblacklist_v4 | while read net; do
			iptables -t filter -A BLOCKGOSNET -s "$net" -m comment --comment "Блокировка госорганов" -j DROP
		done

		# Whitelist for IPv6
		getwhitelist_v6 | while read net; do
			iptables -t filter -A BLOCKGOSNET -s "$net" -m comment --comment "Блокировка госорганов" -j RETURN
		done

		# Blacklist for IPv6
		getblacklist_v6 | while read net; do
			iptables -t filter -A BLOCKGOSNET -s "$net" -m comment --comment "Блокировка госорганов" -j DROP
		done

		# Enabling
		iptables -t filter -I FORWARD -j BLOCKGOSNET
		iptables -t filter -I INPUT   -j BLOCKGOSNET
		;;
	stop)
		# Disabling
		iptables -t filter -D FORWARD -j BLOCKGOSNET
		iptables -t filter -D INPUT   -j BLOCKGOSNET

		# Cleaning the chain
		iptables -t filter -F BLOCKGOSNET

		# Removing the chain
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
