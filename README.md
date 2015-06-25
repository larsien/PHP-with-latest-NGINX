# PHP-with-latest-NGINX
latest NGINX with PHP

####nginx package information
mainline : [http://nginx.org/en/linux_packages.html#mainline](http://nginx.org/en/linux_packages.html#mainline) 
stable   : [http://nginx.org/en/linux_packages.html#stable](http://nginx.org/en/linux_packages.html#stable)

####nginx configuration
Configure default.conf for using PHP in nginx : [reference](http://taking.kr/blog/archives/1003.html)

####Usage

1. download Dockerfile and default.conf
2. docker build --tag nginxphp:0.1 .
3. docker run -d -p 80:80 -v /usr/share/nginx/html:/usr/share/nginx/html  -v /var/log/nginx/:/var/log/nginx --name server nginxphp:0.1

####Snippet 
Added NGINX package information to Dockerfile. like below.
```
#STABLE version
RUN echo "deb http://nginx.org/packages/ubuntu/ trusty nginx" > /etc/apt/sources.list.d/nginx.list && \
    echo "deb-src http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list.d/nginx.list && \
#MAINLINE version
RUN echo deb http://nginx.org/packages/mainline/ubuntu/ trusty nginx > /etc/apt/sources.list.d/nginx.list && \
RUN echo deb-src http://nginx.org/packages/mainline/ubuntu/ trusty nginx >> /etc/apt/sources.list.d/nginx.list && \
```
```
RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf_bak
COPY default.conf /etc/nginx/conf.d/default.conf
```
and add below code to prevent permission denied error more. 
```
#added for permission denied error
RUN sed -i s/\;listen.mode\ \=\ 0660/listen.mode\ \=\ 0660/ /etc/php5/fpm/pool.d/www.conf
RUN sed -i 's/user  nginx/user  www-data/g' /etc/nginx/nginx.conf
```

