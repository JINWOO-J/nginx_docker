# nginx docker 


## Introduction to Nginx
Nginx is a web server that optimizes security and speed that consists of one master process and several worker processes.
Nginx functions in an event-driven way and processes events when a new event occurs asynchronously.
It functions efficiently with a small number of threads, thus uses less CPU and requires less memory.
Using nginx in reverse proxy mode prevents DDoS attacks by throttle setting and enables whitelist based networks.

## Reverse proxy advantage
The reverse proxy receives data from the internal server and sends it to the client. This prevents direct access to the internal server and acts as a relay for indirect access. The reverse proxy has many security advantages.
