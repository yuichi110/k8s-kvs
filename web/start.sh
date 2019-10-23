#!/bin/sh
sed -i -e "s^{{PORT}}^$PORT^g" /etc/nginx/nginx.conf
sed -i -e "s^{{API_PROXY_URL}}^$API_PROXY_URL^g" /etc/nginx/nginx.conf
nginx -g "daemon off;"