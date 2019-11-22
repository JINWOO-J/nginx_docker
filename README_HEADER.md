# nginx docker 

## Introduction to nginx_docker
This project was created to help ICON's PRep-node.
P-Rep node operator should have methods to enhance security.
Setting throttle by using Nginx as Reserve Proxy, P-Reps can protect its network from DDoS attack and able to build a White IP list based network.



## Introduction to Nginx
Nginx is a web server that optimizes security and speed that consists of one master process and several worker processes.
Nginx functions in an event-driven way and processes events when a new event occurs asynchronously.
It functions efficiently with a small number of threads, thus uses less CPU and requires less memory.
Using nginx in reverse proxy mode prevents DDoS attacks by throttle setting and enables whitelist based networks.

## Reverse proxy advantage
The reverse proxy receives data from the internal server and sends it to the client. This prevents direct access to the internal server and acts as a relay for indirect access. The reverse proxy has many security advantages.


## How to build docker

Build an image from a Dockerfile with following command.
You can use the following command to build an image from a Dockerfile.

```bash
$ make
```
 
## How to run nginx image 

Open docker-compose.yml in a text editor and add the following content:

```yaml
version: '3'
services:
   prep:
      image: 'iconloop/prep-node:1907091410x2f8b2e'
      container_name: prep
      cap_add:
         - SYS_TIME
      environment:
         LOOPCHAIN_LOG_LEVEL: "DEBUG"
         DEFAULT_PATH: "/data/loopchain"
         LOG_OUTPUT_TYPE: "file|console"
         LOAD_PEERS_FROM_IISS: "true"
         ENDPOINT_URL: "https://zicon.net.solidwallet.io"
         FIND_NEIGHBOR: "true"
      volumes:
         - ./data:/data

   nginx_throttle:
      image: 'looploy/nginx:1.17.1'
      container_name: nginx_1.17
      environment:
         NGINX_LOG_OUTPUT: 'file'
         NGINX_LOG_TYPE: 'main'
         NGINX_USER: 'root'
         VIEW_CONFIG: "yes"
         USE_NGINX_THROTTLE: "no"   ## DDos (throttle) use = "yes" change
         NGINX_THROTTLE_BY_URI: "yes"
         NGINX_RATE_LIMIT: "200r/s"
         NGINX_BURST: "5"
         NGINX_SET_NODELAY: "no"
         GRPC_PROXY_MODE: "yes"
         USE_VTS_STATUS: "yes"
         TZ: "GMT-9"
         SET_REAL_IP_FROM: "0.0.0.0/0"
         PREP_MODE: "yes"
         NODE_CONTAINER_NAME: "prep"
         PREP_NGINX_ALLOWIP: "no"   ## whitelist use = "yes" change
         NGINX_ALLOW_IP: "0.0.0.0/0"
         NGINX_LOG_FORMAT: '$$realip_remote_addr $$remote_addr  $$remote_user [$$time_local] $$request $$status $$body_bytes_sent $$http_referer "$$http_user_agent" $$http_x_forwarded_for $$request_body'
      volumes:
         - ./data/loopchain/nginx:/var/log/nginx
         - ./user_conf:/etc/nginx/user_conf
      ports:
         - '7100:7100'
         - '9000:9000'
```

run docker-compose
```yaml
$ docker-compose up -d
```


