#!/bin/bash


for IP in `curl -s ${PREP_NODE_LIST_API} -d '{"jsonrpc" : "2.0", "method": "rep_getList", "id": 1234 }' |jq '.' | awk '/target/' | awk -F: '{print$2}' | sed s/\"//g`
do
   echo "allow $IP;" >> /etc/nginx/conf.d/prepnode_allowips.conf
done

oldcksum=`cksum /etc/nginx/conf.d/prepnode_allowips.conf`

inotifywait -e modify,move,create,delete -mr --timefmt '%d/%m/%y %H:%M' --format '%T' /etc/nginx/conf.d/ | while read date time; do

newcksum=`cksum /etc/nginx/conf.d/prepnode_allowips.conf`

if [ "$newcksum" != "$oldcksum" ]; then
   echo "At ${time} on ${date}, config file update detected."
   oldcksum=$newcksum
   nginx -s reload
fi

done
