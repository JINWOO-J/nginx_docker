# nginx docker 


## Introduction to Nginx
Nginx is a web server that optimizes security and speed that consists of one master process and several worker processes.
Nginx functions in an event-driven way and processes events when a new event occurs asynchronously.
It functions efficiently with a small number of threads, thus uses less CPU and requires less memory.
Using nginx in reverse proxy mode prevents DDoS attacks by throttle setting and enables whitelist based networks.

## Reverse proxy advantage
The reverse proxy receives data from the internal server and sends it to the client. This prevents direct access to the internal server and acts as a relay for indirect access. The reverse proxy has many security advantages.

## nginx docker ENV settings
###### made date at 2019-08-26 20:48:02 
| Environment variable | Description|Default value| Allowed value|
|--------|--------|-------|-------|
 TRACKER\_IPLIST| Required for tracker to monitor prep|15.164.151.101 15.164.183.120 52.79.145.149 54.180.178.129 ||
 PREP\_NGINX\_ALLOWIP| `no` :  Set allow come to anyone. `yes`: Set nginx allow ip to whitelist accessible IPs from P|no ||
 PREP\_MODE| PREP\_MODE mode whitelist based nginx usage|no |   (yes/no)|
 PREP\_NODE\_LIST\_API| In order to get prep's white ip list, ENDPOINT API URL (Required input)| ||
 PREP\_LISTEN\_PORT| Choose a prep| ||
 PREP\_PROXY\_PASS\_ENDPOINT| prep's container name for RPC API  (if you selected `PREP\_MODE`, Required input)| ||
 USE\_DOCKERIZE| `go template` usage ( yes/no )|yes  ||
 VIEW\_CONFIG| Config print at launch ( yes/no )|no       ||
 UPSTREAM| upstream setting|localhost||
 DOMAIN| domain setting|localhost          ||
 LOCATION|ADD\_LOCATION|| additional location setting|
 WEBROOT| webroot setting|/var/www/public  ||
 NGINX\_EXTRACONF| additional conf settings| ||
 USE\_DEFAULT\_SERVER| nginx's default conf setting|no  ||
 USE\_DEFAULT\_SERVER\_CONF| nginx's default server conf setting| ||
 NGINX\_USER|www|wwwdata  ||
 NGINX\_SET\_NODELAY| Delay option if rate limit is exceeded|no  | ( yes/no )|
 NUMBER\_PROC| worker processes count|$(nproc)  |  max number of processes|
 WORKER\_CONNECTIONS| WORKER\_CONNECTIONS|4096  ||
 LISTEN\_PORT|80|80      ||
 SENDFILE|on|on||
 SERVER\_TOKENS|off|off||
 KEEPALIVE\_TIMEOUT|65|65||
 KEEPALIVE\_REQUESTS|15|15||
 TCP\_NODELAY|on|on||
 TCP\_NOPUSH|on|on||
 CLIENT\_BODY\_BUFFER\_SIZE|3m|3m||
 CLIENT\_HEADER\_BUFFER\_SIZE|16k|16k||
 CLIENT\_MAX\_BODY\_SIZE|100m|100m||
 FASTCGI\_BUFFER\_SIZE|256K|256K||
 FASTCGI\_BUFFERS|8192 4k|8192 4k||
 FASTCGI\_READ\_TIMEOUT|60|60||
 FASTCGI\_SEND\_TIMEOUT|60|60||
 TYPES\_HASH\_MAX\_SIZE|2048|2048||
 NGINX\_LOG\_TYPE| LOGTYPE (json/default)|default  ||
 NGINX\_LOG\_FORMAT|  '$realip\_remote\_addr $remote\_addr|   ||
 NGINX\_LOG\_OUTPUT| stdout or file  or off|file ||
 USE\_VTS\_STATUS| vts monitoring usage|yes   | (yes/no)|
 USE\_NGINX\_STATUS| nginx status monitoring usage|yes |(yes/no)|
 NGINX\_STATUS\_URI| nginx\_status URI|nginx\_status ||
 NGINX\_STATUS\_URI\_ALLOWIP| nginx\_status URI is only allow requests from this IP address|127.0.0.1 ||
 USE\_PHP\_STATUS|no|no||
 PHP\_STATUS\_URI|php\_status|php\_status||
 PHP\_STATUS\_URI\_ALLOWIP|127.0.0.1|127.0.0.1||
 PRIORTY\_RULE|allow|allow||
 NGINX\_ALLOW\_IP| ADMIN IP ADDR|    ||
 NGINX\_DENY\_IP||||
 NGINX\_LOG\_OFF\_URI||||
 NGINX\_LOG\_OFF\_STATUS||||
 DEFAULT\_EXT\_LOCATION| extension setting  ~/.jsp ~/.php|php  ||
 PROXY\_MODE| gRPC proxy mode usage|no   | (yes/no)|
 GRPC\_PROXY\_MODE| gRPC proxy mode usage|no | (yes/no)|
 USE\_NGINX\_THROTTLE| rate limit usage|no |  (yes/no)|
 NGINX\_THROTTLE\_BY\_URI| URI based rate limit usage (yes/no)|no ||
 NGINX\_THROTTLE\_BY\_IP| IP based rate limit usage (yes/no)|no  ||
 PROXY\_PASS\_ENDPOINT| Endpoint of RPC|     ||
 NGINX\_ZONE\_MEMORY| Sets the shared memory zone for `rate limit`|10m    ||
 NGINX\_RATE\_LIMIT| rate limiting value|100r/s   ||
 NGINX\_BURST|Excessive requests are delayed until their number exceeds the maximum burst size,  maximum queue value ( If the value is `10`, apply from `11`)|10                 ||
 SET\_REAL\_IP\_FROM| SET\_REAL\_IP\_FROM|0.0.0.0/0   ||
 NGINX\_PROXY\_TIMEOUT|90|90  ||
