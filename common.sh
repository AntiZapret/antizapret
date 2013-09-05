# common routines

getlist() {
	FNAME="$1"

	grep -vE '^$|^#' "$FNAME"
}

getblacklist() {
	getlist blacklist.txt
}

getwhitelist() {
	getlist whitelist.txt
}

