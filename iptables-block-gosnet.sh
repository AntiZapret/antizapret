#!/usr/bin/env sh

LOC="$(dirname ${0})"
. "${LOC}"/common.sh


start() {

		# Creating a chain
		iptables -t raw -N BLOCKGOSNET
		iptables -t raw -A BLOCKGOSNET -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

		# Whitelist for IPv4
		getwhitelist_v4 | while read net; do
			iptables -t raw -A BLOCKGOSNET -s "${net}" -m comment --comment "Госорганы (WL)" -j RETURN
		done

		# Blacklist for IPv4
		getblacklist_v4 | while read net; do
			iptables -t raw -A BLOCKGOSNET -s "${net}" -m comment --comment "Госорганы (BL)" -j DROP
		done

		# Whitelist for IPv6
		getwhitelist_v6 | while read net; do
			ip6tables -t raw -A BLOCKGOSNET -s "${net}" -m comment --comment "Госорганы (WL)" -j RETURN
		done

		# Blacklist for IPv6
		getblacklist_v6 | while read net; do
			ip6tables -t raw -A BLOCKGOSNET -s "${net}" -m comment --comment "Госорганы (BL)" -j DROP
		done

		# Enabling
		iptables -t raw -I PREROUTING -j BLOCKGOSNET
}

stop() {
		# Disabling
		iptables -t raw -D PREROUTING -j BLOCKGOSNET

		# Cleaning the chain
		iptables -t raw -F BLOCKGOSNET

		# Removing the chain
		iptables -t raw -X BLOCKGOSNET
}
case "${1}" in
	start)
			start;
		;;
	stop)
			stop;
		;;
	restart)
		stop &&
		start || (
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
