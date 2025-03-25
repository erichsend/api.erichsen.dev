FROM php:8.0-apache

RUN apt-get update && apt-get install -y \
    unzip \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libxml2-dev \
    imagemagick \
    git \
  && docker-php-ext-install mysqli pdo pdo_mysql gd zip xml

RUN curl -sL https://github.com/omeka/Omeka/archive/v3.1.2.tar.gz -o /tmp/omeka.tar.gz && \
    mkdir -p /tmp/omeka && \
    tar -xzvf /tmp/omeka.tar.gz -C /tmp/omeka && \
    cp -a /tmp/omeka/Omeka-3.1.2/. /var/www/html/ && \
    rm -rf /tmp/omeka /tmp/omeka.tar.gz

RUN mv /var/www/html/.htaccess.changeme /var/www/html/.htaccess
RUN chown -R www-data:www-data /var/www/html/files

# Patch search_texts.sql and migration to use InnoDB instead of MyISAM
RUN sed -i 's/ENGINE=MyISAM/ENGINE=InnoDB/g' /var/www/html/application/schema/search_texts.sql && \
    sed -i 's/ENGINE=MyISAM/ENGINE=InnoDB/g' /var/www/html/application/migrations/20120723000000_addSearchText.php

RUN sed -i 's/UNIQUE KEY `unique_schema_migrations` (`version`))/PRIMARY KEY (`version`), UNIQUE KEY `unique_schema_migrations` (`version`))/g' \
    /var/www/html/application/libraries/Omeka/Db/Migration/Manager.php

COPY omeka/docker/plugins.txt /tmp/plugins.txt

RUN mkdir -p /var/www/html/plugins
RUN set -e; \
    while IFS=, read -r PLUGIN_URL SHA; do \
      # Trim any extra whitespace
      PLUGIN_URL=$(echo $PLUGIN_URL | xargs); \
      SHA=$(echo $SHA | xargs); \
      PLUGIN_NAME=$(basename "$PLUGIN_URL" .git); \
      echo "Downloading plugin $PLUGIN_NAME from $PLUGIN_URL at $SHA"; \
      TARBALL_URL="${PLUGIN_URL%}/archive/${SHA}.tar.gz"; \
      curl -L "$TARBALL_URL" -o /tmp/"$PLUGIN_NAME".tar.gz; \
      mkdir -p /var/www/html/plugins/"$PLUGIN_NAME"; \
      tar -xzvf /tmp/"$PLUGIN_NAME".tar.gz -C /var/www/html/plugins/"$PLUGIN_NAME" --strip-components=1; \
      rm /tmp/"$PLUGIN_NAME".tar.gz; \
    done < /tmp/plugins.txt

# Enable Apache rewrite and .htaccess override support
RUN a2enmod rewrite && \
    sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Copy the entrypoint script
COPY omeka/docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the working directory
WORKDIR /var/www/html

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
