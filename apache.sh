#!/usr/bin/env sh

. ./common.sh

LIST='.htaccess_tmp'

# create config file with rules

echo '# WARNING! This file was generated. Do not change!' > $LIST
echo 'order allow,deny' >> $LIST
getlist | while read net; do
    echo "deny from ${net}" >> $LIST
done
echo 'allow from all' >> $LIST


