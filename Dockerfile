FROM debian:buster

MAINTAINER tcordonn <tcordonn@student.42.fr>

ADD /srcs/db.sql /tmp/

# UPDATE
RUN apt-get update
RUN apt-get upgrade

# INSTALL TOOLS
RUN apt-get -y install wget

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
RUN rm /etc/nginx/sites-available/default
RUN rm /etc/nginx/sites-enabled/default
RUN chown -R $USER:$USER /var/www/*
RUN chown -R www-data:www-data /var/www/*
RUN chmod -R 755 /var/www/*
RUN service mysql start
#RUN chown -R www-data:www-data /var/run/mysql/*
RUN mysql -u root --password= < /tmp/db.sql
# /var/run/mysqld/mysqld.sock

#INSTALL WORDPRESS
#SET UP SERVER
COPY srcs/config.inc.php /usr/share/phpmyadmin/config.inc.php
COPY srcs/nginx.conf /etc/nginx/sites-available
COPY srcs/index.php /var/www/mywebsite
RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/nginx.conf
RUN nginx -t
#RUN chmod 755 /usr/bin/script.sh

EXPOSE 80
EXPOSE 443
	
# ENTRYPOINT ["script.sh"]

CMD service nginx restart \
	&& service mysql start \
	&& service php7.3-fpm start \
	&& bash
