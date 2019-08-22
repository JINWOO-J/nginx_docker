#!/bin/sh

PREP_LIST_API=`cat /etc/nginx/policy/.cron-env`

true > /etc/nginx/policy/prepnode_dynamicips_check.conf
for IP in `curl -s ${PREP_LIST_API} -d '{"jsonrpc" : "2.0", "method": "rep_getList", "id": 1234 }' |jq '.' | awk '/target/' | awk -F: '{print$2}' | sed s/\"//g`
do
   echo "allow $IP;" >> /etc/nginx/policy/prepnode_dynamicips_check.conf
done


if [ "diff --brief /etc/nginx/conf.d/prepnode_allowips.conf /etc/nginx/policy/prepnode_dynamicips_check.conf" ]; then
    cp /etc/nginx/policy/prepnode_dynamicips_check.conf /etc/nginx/conf.d/prepnode_allowips.conf
fi
