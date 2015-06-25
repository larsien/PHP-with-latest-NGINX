# LEMP stack as a docker container
#ubuntu 14.04 code name is trusty
FROM ubuntu:14.04
#reference Daniel Watrous from http://software.danielwatrous.com/use-docker-to-build-a-lemp-stack-buildfile/
MAINTAINER Kim Seon HO <larsien85@gmail.com>

# install nginx
RUN export DEBIAN_FRONTEND=noninteractive && \
#STABLE version
    echo "deb http://nginx.org/packages/ubuntu/ trusty nginx" > /etc/apt/sources.list.d/nginx.list && \
    echo "deb-src http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list.d/nginx.list && \
#MAINLINE version
#    echo deb http://nginx.org/packages/mainline/ubuntu/ trusty nginx > /etc/apt/sources.list.d/nginx.list && \
#    echo deb-src http://nginx.org/packages/mainline/ubuntu/ trusty nginx >> /etc/apt/sources.list.d/nginx.list && \
    apt-key adv --fetch-keys "http://nginx.org/keys/nginx_signing.key"
RUN apt-get update && \
    apt-get -y install nginx

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
#old nginx
#RUN mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
#work after 1.8. I didn't test before 1.8.
RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf_bak
COPY default.conf /etc/nginx/conf.d/default.conf

# install PHP
RUN apt-get -y install php5-fpm php5-mysql
RUN sed -i s/\;cgi\.fix_pathinfo\s*\=\s*1/cgi.fix_pathinfo\=0/ /etc/php5/fpm/php.ini

#added for permission denied error
RUN sed -i s/\;listen.mode\ \=\ 0660/listen.mode\ \=\ 0660/ /etc/php5/fpm/pool.d/www.conf
"Dockerfile" 42L, 1790C                                                                                                                                                                  11,1          Top
#added for permission denied error
RUN sed -i s/\;listen.mode\ \=\ 0660/listen.mode\ \=\ 0660/ /etc/php5/fpm/pool.d/www.conf
RUN sed -i 's/user  nginx/user  www-data/g' /etc/nginx/nginx.conf

# prepare php test scripts
RUN echo "<?php phpinfo(); ?>" > /usr/share/nginx/html/info.php

# add volumes for debug and file manipulation
VOLUME ["/var/log/", "/usr/share/nginx/html/"]

EXPOSE 80

CMD service php5-fpm start && nginx
