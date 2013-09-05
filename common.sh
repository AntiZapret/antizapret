# common routines

getblacklist() {
	grep -vE '^$|^#' blacklist.txt
}

getwhitelist() {
	grep -vE '^$|^#' whitelist.txt
}

