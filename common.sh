# common routines

LOC="$(dirname ${0})"

getlist() {
	FNAME="$1"
	grep -E '^[0-9a-fA-F:]' "$FNAME"
}

getblacklist_v4() {
	getlist "${LOC}"/blacklist4.txt
}

getwhitelist_v4() {
	getlist "${LOC}"/whitelist4.txt
}

getblacklist_v6() {
	getlist "${LOC}"/blacklist6.txt
}

getwhitelist_v6() {
	getlist "${LOC}"/whitelist6.txt
}

