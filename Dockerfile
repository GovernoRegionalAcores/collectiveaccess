FROM reinblau/php-apache2

ENV CA_PROVIDENCE_VERSION=1.6
ENV CA_PROVIDENCE_DIR=/var/www/providence-$CA_PROVIDENCE_VERSION
ENV CA_PAWTUCKET_DIR=/var/www

RUN apt-get update && apt-get install -y php5-mysql php5-cli mysql-client
RUN wget -P $CA_PAWTUCKET_DIR https://github.com/collectiveaccess/pawtucket2/archive/develop.zip
RUN unzip $CA_PAWTUCKET_DIR/develop.zip -d $CA_PAWTUCKET_DIR

RUN mv $CA_PAWTUCKET_DIR/pawtucket2-develop /var/ && mv /var/www /var/www2 && mv var/pawtucket2-develop /var/www
RUN mv $CA_PAWTUCKET_DIR/setup.php-dist $CA_PAWTUCKET_DIR/setup.php && mkdir $CA_PAWTUCKET_DIR/media 
RUN cd $CA_PAWTUCKET_DIR/media && ln -s /var/www/providence/media/collectiveaccess/ /var/www/media/collectiveaccess

RUN curl -SsL https://github.com/collectiveaccess/providence/archive/$CA_PROVIDENCE_VERSION.tar.gz | tar -C /var/www/ -xzf -

RUN cd $CA_PROVIDENCE_DIR \
    && mv setup.php-dist setup.php \
    && cd /var/www \
    && mv $CA_PROVIDENCE_DIR providence

ADD php.ini /etc/php5/apache2/php.ini

COPY entrypoint.sh /entrypoint.sh
RUN cd / \
    && chmod 777 entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["/bin/bash", "/root/start.bash"]

