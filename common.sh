# common routines

getlist() {
	FNAME="$1"
	grep -E '^[0-9a-fA-F:]' "$FNAME"
}

getblacklist_v4() {
	getlist blacklist4.txt
}

getwhitelist_v4() {
	getlist whitelist4.txt
}

getblacklist_v6() {
	getlist blacklist6.txt
}

getwhitelist_v6() {
	getlist whitelist6.txt
}

