# nginx docker 


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
nginx:
    image: 'looploy/nginx:1.16.0'
    container_name: nginx_1.16
    environment:
        NGINX_LOG_OUTPUT: 'file'
        NGINX_LOG_TYPE: 'main'
        NGINX_USER: 'root'
        VIEW_CONFIG: "yes"
        PROXY_MODE: "yes"
        USE_NGINX_THROTTLE: "yes"
        # NGINX_THROTTLE_BY_URI: "yes"
        NGINX_RATE_LIMIT: "200r/s"
        NGINX_BURST: "5"
        LISTEN_PORT: 7100
        GRPC_PROXY_MODE: "yes"
        PROXY_PASS_ENDPOINT: "grpc://prep:7100"
        USE_VTS_STATUS: "yes"
        TZ: "GMT-9"
        PREP_MODE: "yes"
        PREP_LISTEN_PORT: 9000
        PREP_PROXY_PASS_ENDPOINT: "http://prep:9000"
        PREP_NODE_LIST_API: "prep:9000/api/v3"
        PREP_NGINX_ALLOWIP: "yes"
        NGINX_ALLOW_IP: "0.0.0.0/0"
        LOCATION: "location ~ /api/ws/* {proxy_pass http://_upstreamer;proxy_http_version 1.1;proxy_set_header Upgrade $$http_upgrade;proxy_set_header Connection 'Upgrade'; proxy_read_timeout 1800s;} location ~ /api/node/* {proxy_pass http://_upstreamer;proxy_http_version 1.1;proxy_set_header Upgrade $$http_upgrade;proxy_set_header Connection 'Upgrade'; proxy_read_timeout 1800s;} "
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


