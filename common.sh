# common routines

getlist() {
	grep -vE '^$|^#' list.txt
}

