#!/bin/bash
set -e

# Optionally set defaults if any of these aren't set in the environment.
: "${S3_ENDPOINT:=https://s3.amazonaws.com}"
: "${S3_EXPIRATION:=10}"
: "${S3_FORCE_SSL:=1}"

cat >/var/www/html/config.ini <<EOF
; Omeka Configuration File

[database]
host     = ${DB_HOST}
username = ${DB_USER}
password = ${DB_PASS}
dbname   = ${DB_NAME}
port     = ${DB_PORT}

[storage]
adapter                           = "Omeka_Storage_Adapter_ZendS3"
adapterOptions.accessKeyId        = "${S3_KEY}"
adapterOptions.secretAccessKey    = "${S3_SECRET}"
adapterOptions.bucket             = "${S3_BUCKET}"
adapterOptions.endpoint           = "${S3_ENDPOINT}"
adapterOptions.expiration         = "${S3_EXPIRATION}"
adapterOptions.forceSSL           = "${S3_FORCE_SSL}"
EOF

# Start Apache in the foreground
apache2-foreground
