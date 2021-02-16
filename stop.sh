#!/bin/bash

echo "Stopping Conjur OSS service..."
docker-compose down

echo "Removing certificate files..."
rm -vf conf/tls/*.crt
rm -vf conf/tls/*.key

echo "Removing admin_data file..."
rm -vf admin_data
