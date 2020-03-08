FROM debian:buster

MAINTAINER tcordonn <tcordonn@student.42.fr>

# UPDATE
RUN apt-get update
RUN apt-get upgrade

# INSTALL NGINX
RUN apt-get -y install nginx

# INSTALL MYSQL
#RUN apt-get install -y mariadb-server mariadb-client

# INSTALL PHP
RUN apt-get -y install php-fpm
RUN mkdir /var/www/mywebsite

# INSTALL TOOLS
#RUN location ~ /\. { deny all; access_log off; log_not_found off; }
#RUN apt-get -y install wget


# COPY CONTENT
#COPY srcs/config.inc.php /usr/share/phpMyAdmin/config.inc.php
RUN rm /etc/nginx/sites-available/default
RUN rm /etc/nginx/sites-enabled/default
COPY srcs/nginx.conf /etc/nginx/sites-available
COPY srcs/index.php /var/www/mywebsite
RUN chown -R www-data:www-data /var/www/*
RUN chmod -R 755 /var/www/*

#INSTALL PHPMYADMIN
#RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
#RUN tar -zxvf phpMyAdmin-4.9.0.1-all-languages.tar.gz
#RUN mv phpMyAdmin-4.9.0.1-all-languages /usr/share/phpMyAdmin

#INSTALL WORDPRESS
#SET UP SERVER
#RUN service mysql start
RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/nginx.conf
RUN nginx -t
#RUN chmod 755 /usr/bin/script.sh

EXPOSE 80
EXPOSE 443
	
# ENTRYPOINT ["script.sh"]

CMD service nginx restart \
	&& service php7.3-fpm start \
	&& bash
