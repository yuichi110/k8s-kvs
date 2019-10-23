From nginx:1.17.3

RUN mkdir /usr/share/nginx/html/static
COPY ./start.sh /usr/local/bin/start.sh
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./docroot/index.html /usr/share/nginx/html
COPY ./docroot/static /usr/share/nginx/html/static
ENV PORT          80
ENV API_PROXY_URL "http://127.0.0.1:8080"

CMD ["/usr/local/bin/start.sh"]