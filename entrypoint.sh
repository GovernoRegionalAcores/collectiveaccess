#!/bin/bash
set -e

#DATABASE INIT/CONFIG
mysql -h $MYSQL_PORT_3306_TCP_ADDR -uroot -p$MYSQL_ENV_MYSQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
mysql -h $MYSQL_PORT_3306_TCP_ADDR -uroot -p$MYSQL_ENV_MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER' IDENTIFIED BY '$DB_PW';"

cd $CA_PROVIDENCE_DIR/media/collectiveaccess && mkdir -p tilepics
cd $CA_PAWTUCKET_DIR && chown www-data:www-data . -R && chmod -R u+rX .
cd $CA_PROVIDENCE_DIR && chown www-data:www-data . -R && chmod -R u+rX .

sweep() {
	local ca="$ca"
	sed -i "s@define(\"__CA_DB_HOST__\", 'localhost');@define(\"__CA_DB_HOST__\", \'$MYSQL_PORT_3306_TCP_ADDR\');@g" setup.php
	sed -i "s@define(\"__CA_DB_USER__\", 'my_database_user');@define(\"__CA_DB_USER__\", \'$DB_USER\');@g" setup.php
	sed -i "s@define(\"__CA_DB_PASSWORD__\", 'my_database_password');@define(\"__CA_DB_PASSWORD__\", \'$DB_PW\');@g" setup.php
	sed -i "s@define(\"__CA_DB_DATABASE__\", 'name_of_my_database');@define(\"__CA_DB_DATABASE__\", \'$DB_NAME\');@g" setup.php
}
cd $CA_PROVIDENCE_DIR
ca='pro'
sweep $ca
cd $CA_PAWTUCKET_DIR
ca='paw'
sweep $ca

exec "$@"
