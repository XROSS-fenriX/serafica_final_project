#!/bin/sh
set -e

PORT_TO_USE=${PORT:-80}

sed -i "s/Listen 80/Listen ${PORT_TO_USE}/" /etc/apache2/ports.conf
sed -i "s/:80/:${PORT_TO_USE}/" /etc/apache2/sites-available/000-default.conf

mkdir -p storage/framework/cache/data
mkdir -p storage/framework/sessions
mkdir -p storage/framework/views
mkdir -p storage/logs
mkdir -p bootstrap/cache

chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache

php artisan storage:link || true
php artisan migrate --force || true
php artisan optimize

exec apache2-foreground