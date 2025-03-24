FROM php:8.0-apache

RUN apt-get update && apt-get install -y \
    git \
    unzip \
 && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://github.com/omeka/Omeka/archive/v3.1.2.tar.gz -o /tmp/omeka.tar.gz && \
    tar -xzvf /tmp/omeka.tar.gz -C /var/www/html --strip-components=1 && \
    rm /tmp/omeka.tar.gz

COPY plugins.txt /tmp/plugins.txt

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


# Copy the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the working directory
WORKDIR /var/www/html

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
