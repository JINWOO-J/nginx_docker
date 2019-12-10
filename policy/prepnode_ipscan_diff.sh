#!/bin/bash

function check_valid_ip(){
    local  ip=$1
    local  stat=1
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

PREP_LIST_API=`cat /etc/nginx/policy/.cron-env`
PREP_AVAIL_API=`cat /etc/nginx/policy/.cron-env-avail`


true > /etc/nginx/policy/localhost.json
health_code_check=`curl --max-time 3 -sk -w "%{http_code}"  ${PREP_AVAIL_API} -o /etc/nginx/policy/localhost.json`

if [[ $health_code_check -eq 200  ]]; then
         echo `date "+%Y-%m-%d %H:%M:%S"` "INFO >> START cron" >> /var/log/nginx/cron.log
         true > /etc/nginx/policy/prepnode_dynamicips_check.conf

         IPLIST=`curl -d '{"jsonrpc": "2.0", "method": "icx_call", "id": 1234, "params": {"from": "hx0000000000000000000000000000000000000000", "to": "cx0000000000000000000000000000000000000000", "dataType": "call", "data": {"method": "getPRepTerm"}}}' ${PREP_LIST_API} |jq '.result.preps[].p2pEndpoint' | sed s/\"//g | sed s/:7100//g`

         for IP in $IPLIST
            do
              if check_valid_ip "$IP"; then
                        echo "allow $IP;" >> /etc/nginx/policy/prepnode_dynamicips_check.conf
              fi
            done

        if [ "diff --brief /etc/nginx/conf.d/prepnode_allowips.conf /etc/nginx/policy/prepnode_dynamicips_check.conf" ]; then
             cp /etc/nginx/policy/prepnode_dynamicips_check.conf /etc/nginx/conf.d/prepnode_allowips.conf
        fi

        echo `date "+%Y-%m-%d %H:%M:%S"` "INFO >> FINISH cron" >> /var/log/nginx/cron.log

else 
        echo `date "+%Y-%m-%d %H:%M:%S"` "FAIL >> health code check fail, cron STOP" >> /var/log/nginx/cron.log

fi
