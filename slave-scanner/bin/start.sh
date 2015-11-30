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

echo "Starting Openvassd"
./openvassd

echo "Starting Openvasmd"
./openvasmd

until ps -ef | grep -v grep | grep -v Init | grep openvasmd
do
	echo "Waiting for Openvas to start successfully..."
	ps -ef | grep -v grep | grep openvasmd || ./openvasmd
	sleep 1
done

echo "Finished startup"

tail -f /usr/local/var/log/openvas/*
