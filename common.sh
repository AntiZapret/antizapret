LOC="$(dirname ${0})"

cd "${LOC}"

getlist() {
	FNAME="${1}"
	grep -E '^[0-9a-fA-F:]' "${FNAME}".txt
	test -e "${FNAME}"_local.txt &&
	grep -E '^[0-9a-fA-F:]' "${FNAME}"_local.txt
}

getblacklist_v4() {
	getlist blacklist4
}

getwhitelist_v4() {
	getlist whitelist4
}

getblacklist_v6() {
	getlist blacklist6
}

getwhitelist_v6() {
	getlist whitelist6
}

getblacklist_all() {
	getblacklist_v4
	getblacklist_v6
}

getwhitelist_all() {
	getwhitelist_v4
	getwhitelist_v6
}
