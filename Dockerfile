FROM php:8.1.18-fpm

RUN apt update && \
    apt install -fuy libzip-dev libfreetype6-dev libjpeg-dev libpng-dev libicu-dev libcurl4-openssl-dev && \
    pecl install zip sendmail openssl && \
    docker-php-ext-enable zip && \
    docker-php-ext-configure gd --with-freetype-dir --with-jpeg-dir && \
    docker-php-ext-install -j$(nproc) gd && \
    docker-php-ext-install -j$(nproc) curl && \
    docker-php-ext-install -j$(nproc) intl && \
    docker-php-ext-install -j$(nproc) mysqli && \
    docker-php-ext-install -j$(nproc) pdo && \
    docker-php-ext-install -j$(nproc) pdo_mysql && \
    docker-php-ext-install -j$(nproc) opcache && \
    docker-php-ext-install -j$(nproc) sockets && \
    php -r 'var_dump(function_exists("imagecreatefromjpeg"));'

COPY php.ini /usr/local/etc/php/php.ini