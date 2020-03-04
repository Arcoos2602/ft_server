FROM debian:buster

MAINTAINER Thomas <Arcoos2602@gmail.com>

RUN apt-get update

RUN apt-get -y install wget

RUN apt-get -y install nginx

ADD script.sh /usr/bin/script.sh

RUN chmod 755 /usr/bin/script.sh

EXPOSE 80

# ENTRYPOINT ["script.sh"]

CMD ["nginx", "-g", "daemon off;"]
