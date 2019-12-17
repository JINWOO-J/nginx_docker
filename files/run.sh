#!/bin/bash
export TRACKER_IPLIST=${TRACKER_IPLIST:-"15.164.151.101 15.164.183.120 52.79.145.149 54.180.178.129"} # Required for tracker to monitor prep-node
export ENDPOINT_IPLIST=${ENDPOINT_IPLIST:-"18.176.140.116 3.115.235.90 15.164.9.144 52.79.53.18 100.20.198.12 100.21.153.11 3.232.240.113 35.173.107.66 18.162.69.96 18.162.80.224 18.140.251.111 18.141.27.125 58.234.156.141 58.234.156.140 210.180.69.103"}
export PREP_NGINX_ALLOWIP=${PREP_NGINX_ALLOWIP:-"no"} # `no` :  Set allow come to anyone. `yes`: Set nginx allow ip to whitelist accessible IPs from P-Rep nodes,  if you want to add white IP address, you must mount to `/etc/nginx/manual_acl`
export PREP_MODE=${PREP_MODE:-"no"} # PREP_MODE mode whitelist based nginx usage #   (yes/no)
export NODE_CONTAINER_NAME=${NODE_CONTAINER_NAME:-"prep"} # container name in order to connect to prep-node
export PREP_LISTEN_PORT=${PREP_LISTEN_PORT:-"9000"} # Choose a prep-node listen port  (Required input)
export PREP_PROXY_PASS_ENDPOINT=${PREP_PROXY_PASS_ENDPOINT:-"http://${NODE_CONTAINER_NAME}:9000"} # prep's container name for RPC API  (if you selected `PREP_MODE`, Required input)
export PREP_NODE_LIST_API=${PREP_NODE_LIST_API:-"${PREP_PROXY_PASS_ENDPOINT}/api/v3"} # In order to get prep's white ip list, ENDPOINT API URL (Required input)
export PREP_AVAIL_API=${PREP_AVAIL_API:-"http://localhost:9000/api/v1/status/peer"}
export CONTAINER_GW=${CONTAINER_GW:-`ip route | grep default | awk '{print $3}'`} #get container gateway, Required to call loopback # container's gateway IP
ENDPOINT_IPLIST="${ENDPOINT_IPLIST} ${CONTAINER_GW}"
export USE_DOCKERIZE=${USE_DOCKERIZE:-"yes"}  # `go template` usage ( yes/no )
export VIEW_CONFIG=${VIEW_CONFIG:-"no"}       # Config print at launch ( yes/no )
export UPSTREAM=${UPSTREAM:-"localhost:9000"} # upstream setting
export DOMAIN=${DOMAIN:-"localhost"}          # domain setting
export LOCATION=${LOCATION:-"#ADD_LOCATION"}  # additional location setting
export WEBROOT=${WEBROOT:-"/var/www/public"}  # webroot setting
export NGINX_EXTRACONF=${NGINX_EXTRACONF:-""} # additional conf settings
export USE_DEFAULT_SERVER=${USE_DEFAULT_SERVER:-"no"}  # nginx's default conf setting
export USE_DEFAULT_SERVER_CONF=${USE_DEFAULT_SERVER_CONF:-""} # nginx's default server conf setting
export NGINX_USER=${NGINX_USER:-"www-data"}  # nginx daemon user
export NGINX_SET_NODELAY=${NGINX_SET_NODELAY:-"no"}  # Delay option if rate limit is exceeded # ( yes/no )

export WEB_SOCKET_URIS=${WEB_SOCKET_URIS:-"/api/ws/* /api/node/*"} # URI for using nginx as a websocket proxy
export NUMBER_PROC=${NUMBER_PROC:-$(nproc)}  # worker processes count  #  max number of processes
export WORKER_CONNECTIONS=${WORKER_CONNECTIONS:-"4096"}  # setting WORKER_CONNECTIONS

export GRPC_LISTEN_PORT=${GRPC_LISTEN_PORT:-"7100"} # Used by gRPC Listen port
export LISTEN_PORT=${LISTEN_PORT:-"${GRPC_LISTEN_PORT}"}

if [[ -z "${LISTEN_PORT}" ]];
then
    export LISTEN_PORT=80
fi

export SENDFILE=${SENDFILE:-"on"}
export SERVER_TOKENS=${SERVER_TOKENS:-"off"}
export KEEPALIVE_TIMEOUT=${KEEPALIVE_TIMEOUT:-"65"}
export KEEPALIVE_REQUESTS=${KEEPALIVE_REQUESTS:-"15"}
export TCP_NODELAY=${TCP_NODELAY:-"on"}
export TCP_NOPUSH=${TCP_NOPUSH:-"on"}
export CLIENT_BODY_BUFFER_SIZE=${CLIENT_BODY_BUFFER_SIZE:-"3m"}
export CLIENT_HEADER_BUFFER_SIZE=${CLIENT_HEADER_BUFFER_SIZE:-"16k"}
export CLIENT_MAX_BODY_SIZE=${CLIENT_MAX_BODY_SIZE:-"100m"}
export FASTCGI_BUFFER_SIZE=${FASTCGI_BUFFER_SIZE:-"256K"}
export FASTCGI_BUFFERS=${FASTCGI_BUFFERS:-"8192 4k"}
export FASTCGI_READ_TIMEOUT=${FASTCGI_READ_TIMEOUT:-"60"}
export FASTCGI_SEND_TIMEOUT=${FASTCGI_SEND_TIMEOUT:-"60"}
export TYPES_HASH_MAX_SIZE=${TYPES_HASH_MAX_SIZE:-"2048"}

export NGINX_LOG_TYPE=${NGINX_LOG_TYPE:-"default"}  # output log format type #  (json/default)
export NGINX_LOG_FORMAT=${NGINX_LOG_FORMAT:-""}   #  '$realip_remote_addr $remote_addr - $remote_user [$time_local] "$request" ' '$status $body_bytes_sent "$http_referer" ' '"$http_user_agent" "$http_x_forwarded_for"'
export NGINX_LOG_OUTPUT=${NGINX_LOG_OUTPUT:-"file"} # output log type # stdout or file  or off
export NGINX_LOG_OPTION=${NGINX_LOG_OPTION:-"escape=none"} # for json logging option # escape=json, escape=none
export USE_VTS_STATUS=${USE_VTS_STATUS:-"yes"}   # vts monitoring usage    # (yes/no)
export USE_NGINX_STATUS=${USE_NGINX_STATUS:-"yes"} # nginx status monitoring usage #(yes/no)
export NGINX_STATUS_URI=${NGINX_STATUS_URI:-"nginx_status"} # nginx_status URI
export NGINX_STATUS_URI_ALLOWIP=${NGINX_STATUS_URI_ALLOWIP:-"127.0.0.1"} # nginx_status URI is only allow requests from this IP address

export USE_PHP_STATUS=${USE_PHP_STATUS:-"no"}
export PHP_STATUS_URI=${PHP_STATUS_URI:-"php_status"}
export PHP_STATUS_URI_ALLOWIP=${PHP_STATUS_URI_ALLOWIP:-"127.0.0.1"}

export PRIORTY_RULE=${PRIORTY_RULE:-"allow"}
export NGINX_ALLOW_IP=${NGINX_ALLOW_IP:-""}    # Administrator IP addr for detail monitoring
export NGINX_DENY_IP=${NGINX_DENY_IP:-""}
export NGINX_LOG_OFF_URI=${NGINX_LOG_OFF_URI:-""}
export NGINX_LOG_OFF_STATUS=${NGINX_LOG_OFF_STATUS:-""}

# export NGINX_PROXY_CACHE_PATH=${NGINX_PROXY_CACHE_PATH:-""}
export DEFAULT_EXT_LOCATION=${DEFAULT_EXT_LOCATION:-"php"}  # extension setting  ~/.jsp ~/.php

export PROXY_MODE=${PROXY_MODE:-"no"}   # gRPC proxy mode usage # (yes/no)
export GRPC_PROXY_MODE=${GRPC_PROXY_MODE:-"no"} # gRPC proxy mode usage # (yes/no)

export USE_NGINX_THROTTLE=${USE_NGINX_THROTTLE:-"no"} # rate limit usage #  (yes/no)

export NGINX_THROTTLE_BY_URI=${NGINX_THROTTLE_BY_URI:-"no"} # URI based rate limit usage (yes/no)
export NGINX_THROTTLE_BY_IP=${NGINX_THROTTLE_BY_IP:-"no"}  # IP based rate limit usage (yes/no)
export NGINX_THROTTLE_BY_IP_VAR=${NGINX_THROTTLE_BY_IP_VAR:-'$http_true_client_ip'} # IP variable to be used for rate limit

export PROXY_PASS_ENDPOINT=${PROXY_PASS_ENDPOINT:-"grpc://${NODE_CONTAINER_NAME}:7100"}     # proxy endporint of gRPC

export NGINX_ZONE_MEMORY=${NGINX_ZONE_MEMORY:-"10m"}    # Sets the shared memory zone for `rate limit`
export NGINX_RATE_LIMIT=${NGINX_RATE_LIMIT:-"100r/s"}   # rate limiting value
export NGINX_BURST=${NGINX_BURST:-"10"}                 #Excessive requests are delayed until their number exceeds the maximum burst size,  maximum queue value ( If the value is `10`, apply from `11`)

export SET_REAL_IP_FROM=${SET_REAL_IP_FROM:-"0.0.0.0/0"}   # SET_REAL_IP_FROM


RED='\033[0;31m'
NOCOLOR="\033[0m"

## waiting for prep before nginx start
while ! dockerize -wait tcp://$NODE_CONTAINER_NAME:9000; do
  >&2 echo -e "${RED}Waiting for $NODE_CONTAINER_NAME ${NOCOLOR}"
  sleep 1
done


## Nginx allow dynamic prep ip 설정
if [ $PREP_MODE == "yes" ];
then
  sh /etc/nginx/policy/prepnode_reload.sh &
  cron
fi

if [[ $NGINX_SET_NODELAY -eq "yes" ]];
then
    export NGINX_NODELAY="nodelay"
else
    export NGINX_NODELAY=""
fi

export NGINX_PROXY_TIMEOUT=${NGINX_PROXY_TIMEOUT:-"90"}


RESET='\e[0m'  # RESET
BWHITE='\e[7m';    # backgroud White

IRED='\e[0;91m'         # Rosso
IGREEN='\e[0;92m'       # Verde
RESET='\e[0m'  # RESET

function print_w(){
	printf "${BWHITE} ${1} ${RESET}\n";
}
function print_g(){
	printf "${IGREEN} ${1} ${RESET}\n";
}

if [ $USE_DEFAULT_SERVER = "yes" ]
then
    export USE_DEFAULT_SERVER_CONF="server {listen ${LISTEN_PORT} default_server; server_name _; return 444;}"
    if [ $DOMAIN = "localhost" ]
    then
        export DOMAIN="default";
        print_g "default server "${USE_DEFAULT_SERVER}" - ${DOMAIN}"
    fi
fi

if [ $USE_DOCKERIZE == "yes" ];
then
    print_g "USE the dockerize template - ${NGINX_VERSION}"
    dockerize -template /etc/nginx/default.tmpl | grep -ve '^ *$'  > /etc/nginx/sites-available/default.conf
    dockerize -template /etc/nginx/nginx_conf.tmpl | grep -ve '^ *$' > /etc/nginx/nginx.conf
    dockerize -template /etc/nginx/allow_conf.tmpl | grep -ve '^ *$' > /etc/nginx/conf.d/tracker_IP.conf
    dockerize -template /etc/nginx/endpoint_allow_conf.tmpl | grep -ve '^ *$' > /etc/nginx/conf.d/main_endpoint_IP.conf
fi

if [ $VIEW_CONFIG == "yes" ];
then    
    cat /etc/nginx/nginx.conf
    cat /etc/nginx/sites-available/default.conf
fi

print_w "START >> ${NGINX_VERSION}"

echo $PREP_NODE_LIST_API > /etc/nginx/policy/.cron-env
echo $PREP_AVAIL_API > /etc/nginx/policy/.cron-env-avail

printenv | grep -v EXTRA | grep -v  LS_COLORS | grep -v '^_' | awk -F "=" '{print $1 "=" "\"" $2 "\"" }'> ./docker-envs

nginx
