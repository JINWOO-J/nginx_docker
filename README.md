## nginx docker setting

| enviroment variable |default |  Description|
|--------|--------|------|
 USE\_DOCKERIZE|yes  | go template 사용 여부 ( yes/no )
 VIEW\_CONFIG|no       | 시작시 config 출력 여부 ( yes/no )
 UPSTREAM|localhost|localhost
 DOMAIN|localhost          | domain 설정
 LOCATION||ADD\_LOCATION  
 WEBROOT|/var/www/public  | webroot 설정
 NGINX\_EXTRACONF| | 추가적인 conf 설정 
 USE\_DEFAULT\_SERVER|no  | default 설정
 USE\_DEFAULT\_SERVER\_CONF| | default 설정
 NGINX\_USER|wwwdata  | nginx daemon user
 NUMBER\_PROC|$(nproc)  | worker\_processes 수 ( 기본은 cpu 코어수 )
 WORKER\_CONNECTIONS|4096  | WORKER\_CONNECTIONS
 LISTEN\_PORT|80      |80      
 SENDFILE|on|on
 SERVER\_TOKENS|off|off
 KEEPALIVE\_TIMEOUT|65|65
 KEEPALIVE\_REQUESTS|15|15
 TCP\_NODELAY|on|on
 TCP\_NOPUSH|on|on
 CLIENT\_BODY\_BUFFER\_SIZE|3m|3m
 CLIENT\_HEADER\_BUFFER\_SIZE|16k|16k
 CLIENT\_MAX\_BODY\_SIZE|100m|100m
 FASTCGI\_BUFFER\_SIZE|256K|256K
 FASTCGI\_BUFFERS|8192 4k|8192 4k
 FASTCGI\_READ\_TIMEOUT|60|60
 FASTCGI\_SEND\_TIMEOUT|60|60
 TYPES\_HASH\_MAX\_SIZE|2048|2048
 NGINX\_LOG\_TYPE|default  | LOGTYPE (json/default)
 NGINX\_LOG\_FORMAT|   |  '$realip\_remote\_addr $remote\_addr  $remote\_user [$time\_local] $request ' '$status $body\_bytes\_sent $http\_referer ' '$http\_user\_agent $http\_x\_forwarded\_for'
 NGINX\_LOG\_OUTPUT|file | stdout or file  or off
 USE\_VTS\_STATUS|yes   | vts monitoring
 USE\_NGINX\_STATUS|yes | nginx\_status 사용 여부
 NGINX\_STATUS\_URI|nginx\_status | nginx\_status URI
 NGINX\_STATUS\_URI\_ALLOWIP|127.0.0.1 | nginx\_status URI 허용 아이피
 USE\_PHP\_STATUS|no|no
 PHP\_STATUS\_URI|php\_status|php\_status
 PHP\_STATUS\_URI\_ALLOWIP|127.0.0.1|127.0.0.1
 PRIORTY\_RULE|allow|allow
 NGINX\_ALLOW\_IP|    | ADMIN IP ADDR
 NGINX\_DENY\_IP||
 NGINX\_LOG\_OFF\_URI||
 NGINX\_LOG\_OFF\_STATUS||
 DEFAULT\_EXT\_LOCATION|php  | extension 설정  ~/.jsp ~/.php
 PROXY\_MODE|no   | Proxy mode 사용 여부 (yes/no)
 GRPC\_PROXY\_MODE|no | gRPC proxy mode 사용 여부 (yes/no)
 USE\_NGINX\_THROTTLE|no | rate limit 사용 여부  (yes/no)
 NGINX\_THROTTLE\_BY\_URI|no | URI 기반의 rate limit 사용 여부  (yes/no)
 NGINX\_THROTTLE\_BY\_IP|no  | IP 기반의 rate limit 사용 여부  (yes/no)
 PROXY\_PASS\_ENDPOINT|     | proxy\_pass 의 endpoint
 NGINX\_ZONE\_MEMORY|10m    |rate limit에 사용되는 저장소 크기
 NGINX\_RATE\_LIMIT|100r/s   | rate limit 임계치
 NGINX\_BURST|10                 | rate limit을 초과시, 저장하는 최대 큐값 (10일 경우 limit을 넘어가는 11번째 부터 적용)
 SET\_REAL\_IP\_FROM|0.0.0.0/0   | SET\_REAL\_IP\_FROM
 NGINX\_PROXY\_TIMEOUT|90  |90  
