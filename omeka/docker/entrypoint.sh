#!/bin/bash
set -e

# Optionally set defaults if any of these aren't set in the environment.
: "${S3_ENDPOINT:=https://s3.amazonaws.com}"
: "${S3_EXPIRATION:=10}"
: "${S3_FORCE_SSL:=1}"

cat >/var/www/html/db.ini <<EOF
[database]
host     = "${DB_HOST}"
username = "${DB_USER}"
password = "${DB_PASS}"
dbname   = "${DB_NAME}"
port     = "${DB_PORT}"

EOF

cat >/var/www/html/application/config/config.ini <<EOF
[site]
[storage]
storage.adapter                           = "Omeka_Storage_Adapter_ZendS3"
storage.adapterOptions.accessKeyId        = "${S3_KEY}"
storage.adapterOptions.secretAccessKey    = "${S3_SECRET}"
storage.adapterOptions.bucket             = "${S3_BUCKET}"
storage.adapterOptions.endpoint           = "${S3_ENDPOINT}"
storage.adapterOptions.expiration         = "${S3_EXPIRATION}"
storage.adapterOptions.forceSSL           = "${S3_FORCE_SSL}"
[log]
[debug]
EOF

# Start Apache in the foreground
apache2-foreground
