FROM openresty/openresty:1.15.8.3-centos

COPY cmd/kunlun.lua /usr/bin/kunlun

COPY kunlun-0.1.0-1.all.rock /kunlun-0.1.0-1.all.rock

COPY conf/mime.types /usr/local/kunlun/conf/

RUN chmod +x /usr/bin/kunlun && luarocks install /kunlun-0.1.0-1.all.rock

CMD ["sh", "-c", "/usr/bin/kunlun help"]
