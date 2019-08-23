#!/bin/bash
export USER_NGINX_ALLOWIP=${USER_NGINX_ALLOWIP:-"no"} # prep node IP 외 allow ip 추가 여부 (yes/no), yes 경우 해당경로/etc/nginx/user_conf 마운트 필수
export PREP_MODE=${PREP_MODE:-"no"} # nginx allow ip 가 dynamic 할 경우 (yes/no)
export PREP_NODE_LIST_API=${PREP_NODE_LIST_API:-""} # prep node ip check URL API (필수)
export PREP_LISTEN_PORT=${PREP_LISTEN_PORT:-""} # prep mode 시 필수
export PREP_PROXY_PASS_ENDPOINT=${PREP_PROXY_PASS_ENDPOINT:-""} # prep mode 시 필수
export USE_DOCKERIZE=${USE_DOCKERIZE:-"yes"}  # go template 사용 여부 ( yes/no )
export VIEW_CONFIG=${VIEW_CONFIG:-"no"}       # 시작시 config 출력 여부 ( yes/no )
export UPSTREAM=${UPSTREAM:-"localhost:9000"} # upstream 설정 
export DOMAIN=${DOMAIN:-"localhost"}          # domain 설정
export LOCATION=${LOCATION:-"#ADD_LOCATION"}  # location 설정
export WEBROOT=${WEBROOT:-"/var/www/public"}  # webroot 설정
export NGINX_EXTRACONF=${NGINX_EXTRACONF:-""} # 추가적인 conf 설정 
export USE_DEFAULT_SERVER=${USE_DEFAULT_SERVER:-"no"}  # default 설정
export USE_DEFAULT_SERVER_CONF=${USE_DEFAULT_SERVER_CONF:-""} # default 설정
export NGINX_USER=${NGINX_USER:-"www-data"}  # nginx daemon user

export NUMBER_PROC=${NUMBER_PROC:-$(nproc)}  # worker_processes 수 ( 기본은 cpu 코어수 )
export WORKER_CONNECTIONS=${WORKER_CONNECTIONS:-"4096"}  # WORKER_CONNECTIONS

export LISTEN_PORT=${LISTEN_PORT:-"80"}      

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

export NGINX_LOG_TYPE=${NGINX_LOG_TYPE:-"default"}  # LOGTYPE (json/default)
export NGINX_LOG_FORMAT=${NGINX_LOG_FORMAT:-""}   #  '$realip_remote_addr $remote_addr - $remote_user [$time_local] "$request" ' '$status $body_bytes_sent "$http_referer" ' '"$http_user_agent" "$http_x_forwarded_for"'
export NGINX_LOG_OUTPUT=${NGINX_LOG_OUTPUT:-"file"} # stdout or file  or off
 
export USE_VTS_STATUS=${USE_VTS_STATUS:-"yes"}   # vts monitoring
export USE_NGINX_STATUS=${USE_NGINX_STATUS:-"yes"} # nginx_status 사용 여부
export NGINX_STATUS_URI=${NGINX_STATUS_URI:-"nginx_status"} # nginx_status URI
export NGINX_STATUS_URI_ALLOWIP=${NGINX_STATUS_URI_ALLOWIP:-"127.0.0.1"} # nginx_status URI 허용 아이피

export USE_PHP_STATUS=${USE_PHP_STATUS:-"no"}
export PHP_STATUS_URI=${PHP_STATUS_URI:-"php_status"}
export PHP_STATUS_URI_ALLOWIP=${PHP_STATUS_URI_ALLOWIP:-"127.0.0.1"}

export PRIORTY_RULE=${PRIORTY_RULE:-"allow"}
export NGINX_ALLOW_IP=${NGINX_ALLOW_IP:-""}    # ADMIN IP ADDR
export NGINX_DENY_IP=${NGINX_DENY_IP:-""}
export NGINX_LOG_OFF_URI=${NGINX_LOG_OFF_URI:-""}
export NGINX_LOG_OFF_STATUS=${NGINX_LOG_OFF_STATUS:-""}

# export NGINX_PROXY_CACHE_PATH=${NGINX_PROXY_CACHE_PATH:-""}
export DEFAULT_EXT_LOCATION=${DEFAULT_EXT_LOCATION:-"php"}  # extension 설정  ~/.jsp ~/.php

export PROXY_MODE=${PROXY_MODE:-"no"}   # Proxy mode 사용 여부 (yes/no)
export GRPC_PROXY_MODE=${GRPC_PROXY_MODE:-"no"} # gRPC proxy mode 사용 여부 (yes/no)

export USE_NGINX_THROTTLE=${USE_NGINX_THROTTLE:-"no"} # rate limit 사용 여부  (yes/no)

export NGINX_THROTTLE_BY_URI=${NGINX_THROTTLE_BY_URI:-"no"} # URI 기반의 rate limit 사용 여부  (yes/no)
export NGINX_THROTTLE_BY_IP=${NGINX_THROTTLE_BY_IP:-"no"}  # IP 기반의 rate limit 사용 여부  (yes/no)

export PROXY_PASS_ENDPOINT=${PROXY_PASS_ENDPOINT:-""}     # proxy_pass 의 endpoint

export NGINX_ZONE_MEMORY=${NGINX_ZONE_MEMORY:-"10m"}    #rate limit에 사용되는 저장소 크기
export NGINX_RATE_LIMIT=${NGINX_RATE_LIMIT:-"100r/s"}   # rate limit 임계치
export NGINX_BURST=${NGINX_BURST:-"10"}                 # rate limit을 초과시, 저장하는 최대 큐값 (10일 경우 limit을 넘어가는 11번째 부터 적용)
export SET_REAL_IP_FROM=${SET_REAL_IP_FROM:-"0.0.0.0/0"}   # SET_REAL_IP_FROM

## Nginx allow dynamic prep ip 설정
if [ $PREP_MODE == "yes" ];
then
  sh /etc/nginx/policy/prepnode_reload.sh &
  cron
fi


if [[ $NGINX_SET_NODELAY -eq "yes" ]];                  # rate limit 초과시 delay를 주는 옵션  (yes/no)
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
    print_g "USE the dockerize template${NGINX_VERSION}"
    dockerize -template /etc/nginx/default.tmpl | grep -ve '^ *$'  > /etc/nginx/sites-available/default.conf
    dockerize -template /etc/nginx/nginx_conf.tmpl | grep -ve '^ *$' > /etc/nginx/nginx.conf
fi

if [ $VIEW_CONFIG == "yes" ];
then    
    cat /etc/nginx/nginx.conf
    cat /etc/nginx/sites-available/default.conf
fi

print_w "START >> ${NGINX_VERSION}"

echo $PREP_NODE_LIST_API > /etc/nginx/policy/.cron-env

nginx
