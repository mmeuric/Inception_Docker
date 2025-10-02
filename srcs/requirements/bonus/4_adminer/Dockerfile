ARG DEBIAN_VERSION
FROM debian:${DEBIAN_VERSION:-12}

RUN apt-get -y update && \
    apt-get -y install wget curl php php-mysql && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/adminer && \
    wget https://github.com/vrana/adminer/releases/download/v5.3.0/adminer-5.3.0.php -O /var/www/adminer/index.php && \
    chmod 755 /var/www/adminer/index.php

EXPOSE 80

ENTRYPOINT ["php", "-S", "0.0.0.0:80", "-t", "/var/www/adminer"]
