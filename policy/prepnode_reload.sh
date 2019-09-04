#!/bin/bash
#. /docker-envs
source /docker-envs

repshash=`curl -s ${PREP_NODE_LIST_API} -d '{ "jsonrpc" : "2.0", "method": "icx_getBlock", "id": 1234}' | jq '.result.repsHash'`

for IP in `curl -s ${PREP_NODE_LIST_API} -d '{"jsonrpc" : "2.0", "method": "rep_getListByHash", "id": 1234, "params": {"repsHash": '${repshash}'}}' |jq '.result[].p2pEndpoint' | sed s/\"//g | awk -F: '{print$1}'`
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
