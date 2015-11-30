#!/bin/bash

echo "Starting Openvas..."

service postgresql start

echo "Wait until postgresql is ready"

until grep "database system is ready to accept connections" /var/log/postgresql/postgresql-9.1-main.log 
do 
	echo "Waiting for PostgreSQL to start..."
	sleep 1
done

service redis-server start

cd /usr/local/sbin

echo "Starting gsad for debug"
# http://wiki.openvas.org/index.php/Edit_the_SSL_ciphers_used_by_GSAD
./gsad --listen=0.0.0.0 --gnutls-priorities="SECURE128:-AES-128-CBC:-CAMELLIA-128-CBC:-VERS-SSL3.0:-VERS-TLS1.0"

echo "Starting Openvassd"
./openvassd

echo "Rebuilding openvasmd"
n=0
until [ $n -eq 6 ]
do
	        timeout 10m openvasmd --rebuild -v --progress;
		if [ $? -eq 0 ]; then
			break;
		fi
		sleep 5
		echo "Rebuild failed, attempt: $n"
	        n=$[$n+1]
done

echo "Starting Openvasmd"
./openvasmd

echo "Finished startup"

tail -f /usr/local/var/log/openvas/*
