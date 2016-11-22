#!/usr/bin/env sh

LOC="$(dirname ${0})"
. "${LOC}"/common.sh

LIST='./nginx/govblock.conf'
BLOCKER='./nginx/site-example.conf'
REDIRECT_URL="${REDIRECT_URL:-http://pastebin.com/raw.php?i=9pabJfqB}"

# create config file with rules
LIST_PARENT=`dirname ${LIST}`
mkdir -p "${LIST_PARENT}"
echo '# WARNING! This file was generated. Do not change!' > "${LIST}"
echo 'govblock.conf;'
echo 'geo $gov_user {' >> "${LIST}"
echo 'default 0;' >> "${LIST}"
getblacklist_all | while read net; do
    echo "${net} 1;" >> "${LIST}"
done
echo '}' >> "${LIST}"

# create config file which does actual blocking
# visitors are redirected to $REDIRECT_URL
echo '# WARNING! This file was generated. Do not change!' > "${BLOCKER}"
echo 'if ($gov_user = 1) {' >> "${BLOCKER}"
echo "rewrite ^ ${REDIRECT_URL};" >> "${BLOCKER}"
echo '}' >> "${BLOCKER}"
