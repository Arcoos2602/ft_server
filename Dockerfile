FROM debian:buster

MAINTAINER tcordonn <tcordonn@student.42.fr>

# UPDATE
RUN apt-get update
RUN apt-get upgrade

# INSTALL NGINX
RUN apt-get -y install nginx

# INSTALL MYSQL
RUN apt-get install -y mariadb-server mariadb-client

# INSTALL PHP
RUN apt-get -y install php-fpm php-mysql php-cli

# INSTALL TOOLS
RUN apt-get -y install wget

# COPY CONTENT
COPY srcs/config.inc.php /usr/share/phpMyAdmin/config.inc.php 

#INSTALL PHPMYADMIN
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
RUN tar -zxvf phpMyAdmin-4.9.0.1-all-languages.tar.gz
RUN mv phpMyAdmin-4.9.0.1-all-languages /usr/share/phpMyAdmin

#INSTALL WORDPRESS

#SET UP SERVER
RUN service mysql start
#RUN chmod 755 /usr/bin/script.sh

EXPOSE 80

# ENTRYPOINT ["script.sh"]

CMD ["nginx", "-g", "daemon off;"]
