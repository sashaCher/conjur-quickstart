#!/bin/bash -e

CONJUR_ACCOUNT="myorg"

echo "Pulling container images..."
docker-compose pull

echo "Generating data_key..."
export CONJUR_DATA_KEY="$(docker-compose run --no-deps --rm conjur data-key generate | tr -d '[:space:]')"

echo "Starting Conjur OSS service..."
docker-compose up -d
docker-compose exec conjur conjurctl wait

echo "Creating Conjur account and admin user..."
docker-compose exec conjur conjurctl account create $CONJUR_ACCOUNT > admin_data

echo "Initializing Conjur client..."
docker-compose exec client bash -c "yes \"yes\" | conjur init -u https://proxy -a $CONJUR_ACCOUNT"

echo "Logining Conjur client with admin user..."
ADMIN_AUTHN_API_KEY="$(tail -n 1 admin_data | awk '{ print $NF }' | tr -d '\r' | tr -d '\n')"
docker-compose exec client bash -c "yes \"$ADMIN_AUTHN_API_KEY\" | conjur authn login -u admin"
