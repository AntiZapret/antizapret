!/bin/bash
while read net; do
wh=`whois $net |grep descr`
echo $net $wh >>listd.txt
        done < list.txt

exit 0
