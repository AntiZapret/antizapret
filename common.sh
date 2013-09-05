# common routines

getlist() {
	FNAME="$1"

	grep -E '^[0-9]' "$FNAME"
}

getblacklist() {
	getlist blacklist.txt
}

getwhitelist() {
	getlist whitelist.txt
}

