FROM debian:buster

MAINTAINER tcordonn <tcordonn@student.42.fr>

# UPDATE
RUN apt-get update
RUN apt-get upgrade

# INSTALL TOOLS
RUN apt-get -y install wget
RUN apt install unzip

ADD /srcs/db.sql /tmp/
#ADD /srcs/create_tables.sql  /usr/share/phpmyadmin/sql/create_tables.sql
# INSTALL NGINX
RUN apt-get -y install nginx

# INSTALL MYSQL
RUN apt-get install -y mariadb-server

# INSTALL PHP
RUN apt-get -y install \
	php-mysql \
	php-fpm \
	php-cli
RUN apt-get -y install wget
RUN mkdir /var/www/mywebsite

# INSTALL TOOLS
#RUN location ~ /\. { deny all; access_log off; log_not_found off; }

#COPY srcs/config.inc.php /usr/share/phpMyAdmin/config.inc.php
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz \
	&& tar xvf phpMyAdmin-4.9.0.1-all-languages.tar.gz \
	&& mv phpMyAdmin-4.9.0.1-all-languages/ /usr/share/phpmyadmin \
	&& cp /usr/share/phpmyadmin/config.sample.inc.php /usr/share/phpmyadmin/config.inc.php
#COPY srcs/config.inc.php /usr/share/phpmyadmin/config.inc.php
RUN ln -s /usr/share/phpmyadmin /var/www/phpmyadmin
RUN rm /etc/nginx/sites-available/default
RUN rm /etc/nginx/sites-enabled/default
COPY srcs/nginx.conf /etc/nginx/sites-available
COPY srcs/phpmyadmin.conf /etc/nginx/sites-available
COPY srcs/index.php /var/www/mywebsite
RUN chown -R $USER:$USER /var/www/*
RUN chown -R www-data:www-data /var/www/*
RUN chmod -R 755 /var/www/*
RUN service mysql start && mysql -u root  --password= < /tmp/db.sql \
	&& yes "" | openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned
#INSTALL PHPMYADMIN
#INSTALL WORDPRESS
#SET UP SERVER
RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/nginx.conf
RUN ln -s /etc/nginx/sites-available/phpmyadmin.conf /etc/nginx/sites-enabled/phpmyadmin.conf
#RUN chmod 755 /usr/bin/script.sh

EXPOSE 80
EXPOSE 443
# ENTRYPOINT ["script.sh"]

CMD service nginx restart \
	&& service mysql start \
	&& service php7.3-fpm start \
	&& bash
