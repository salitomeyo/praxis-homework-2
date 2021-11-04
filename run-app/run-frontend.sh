#!/usr/bin/env bash

cd /shared
sudo tar -xf ./dist.tar.gz

sudo yum install nginx -y

cd /etc/nginx
cat <<-'default_config' > /etc/nginx/nginx.conf
user  nginx;
worker_processes  1;
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;
events {
  worker_connections  1024;
}
http {
  include       /etc/nginx/mime.types;
  default_type  application/octet-stream;
  log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';
  access_log  /var/log/nginx/access.log  main;
  sendfile        on;
  keepalive_timeout  65;
  server {
    listen       80;
    server_name  localhost;
    location / {
      root   /shared/dist;
      index  index.html;
      try_files $uri $uri/ /shared/dist/index.html;
    }
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
      root   /usr/share/nginx/html;
    }
  }
}
default_config

sudo systemctl start nginx
sudo systemctl enable nginx

sudo systemctl reload nginx