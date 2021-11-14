#!/bin/bash

cat "MOTD"

if [ -z $1 ]
then
        echo './siadcon.sh <list of domains>'
        exit 1
fi

echo 'Looking for sub-domains... >>>'

while read line
do
    for var in $line
    do
        echo 'Enumerating:' $var

        subfinder -silent -d $var > out1
        cat out1 >> subs1

        assetfinder -subs-only $var > out2
        cat out2 >> subs2

        rm out1 out2
    done
done < $1

sort -u subs1 subs2 > all_subs
rm subs1 subs2

echo 'Saved subdomains to all_subs'

echo 'Finding live hosts...'

cat all_subs | httprobe > live_subs
echo 'Saved live hosts to live_subs'
echo 'Cheking for subdomain takeover...'

subjack -w all_subs -a

echo 'DONE'
