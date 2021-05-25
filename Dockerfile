FROM ubuntu:20.04

ENV APACHE_RUN_USER     www-data
ENV APACHE_RUN_GROUP    www-data
ENV APACHE_LOG_DIR      /var/log/apache2
ENV APACHE_PID_FILE     /var/run/apache2.pid
ENV APACHE_RUN_DIR      /var/run/apache2
ENV APACHE_LOCK_DIR     /var/lock/apache2
ENV APACHE_LOG_DIR      /var/log/apache2

ENV CA_PROVIDENCE_VERSION=1.7.11
ENV CA_PROVIDENCE_DIR=/var/www/providence
ENV CA_PAWTUCKET_VERSION=1.7.6
ENV CA_PAWTUCKET_DIR=/var/www
ENV TZ=Europe/Lisbon

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y apache2 \
					php7.4 \
					libapache2-mod-php7.4 \
					curl \
					php-mysql \
					mysql-client \
					curl \
					php7.4-curl \
					php7.4-xml \
					zip \
					wget \
					ffmpeg \
					ghostscript \
					imagemagick \
					php7.4-gd \
					libreoffice \
					php7.4-zip

#GMAGICK
RUN apt-get install -y php-pear php7.4-dev graphicsmagick libgraphicsmagick1-dev \
	&& pecl install gmagick-2.0.4RC1

RUN curl -SsL https://github.com/collectiveaccess/providence/archive/$CA_PROVIDENCE_VERSION.tar.gz | tar -C /var/www/ -xzf -
RUN mv /var/www/providence-$CA_PROVIDENCE_VERSION /var/www/providence
RUN cd $CA_PROVIDENCE_DIR && cp setup.php-dist setup.php

RUN curl -SsL https://github.com/collectiveaccess/pawtucket2/archive/$CA_PAWTUCKET_VERSION.tar.gz | tar -C /var/www/ -xzf -
RUN mv $CA_PAWTUCKET_DIR/pawtucket2-$CA_PAWTUCKET_VERSION/* /var/www
RUN cd $CA_PAWTUCKET_DIR && cp setup.php-dist setup.php
RUN sed -i "s@DocumentRoot \/var\/www\/html@DocumentRoot \/var\/www@g" /etc/apache2/sites-available/000-default.conf
RUN rm -rf /var/www/html
RUN ln -s /$CA_PROVIDENCE_DIR/media /$CA_PAWTUCKET_DIR/media
RUN chown -R www-data:www-data /var/www
#COPY php.ini /etc/php/7.0/cli/php.ini

COPY php.ini /etc/php/7.4/apache2/php.ini
COPY entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD [ "/usr/sbin/apache2", "-DFOREGROUND" ]


