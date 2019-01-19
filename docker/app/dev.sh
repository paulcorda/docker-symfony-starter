#!/bin/sh

# Needed because we override the project dir inside the container using Compose volumes
composer install

# Remove older log files
rm -rf /app/var/log/*

# Run PHP
docker-php-entrypoint php-fpm
