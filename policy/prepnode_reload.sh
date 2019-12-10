#!/bin/bash
#. /docker-envs
source /docker-envs
PREP_LIST_API=`cat /etc/nginx/policy/.cron-env`

IPLIST=`curl -d '{"jsonrpc": "2.0", "method": "icx_call", "id": 1234, "params": {"from": "hx0000000000000000000000000000000000000000", "to": "cx0000000000000000000000000000000000000000", "dataType": "call", "data": {"method": "getPRepTerm"}}}' ${PREP_LIST_API} |jq '.result.preps[].p2pEndpoint' | sed s/\"//g | sed s/:7100//g`

for IP in $IPLIST
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
