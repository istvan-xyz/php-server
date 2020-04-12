FROM php:7.3-fpm

RUN apt update && \
    apt install -fuy libzip-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libicu-dev libcurl4-openssl-dev && \
    pecl install zip && \
    docker-php-ext-enable zip && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/freetype2 --with-jpeg-dir=/usr/include && \
    docker-php-ext-install -j$(nproc) curl && \
    docker-php-ext-install -j$(nproc) gd && \
    docker-php-ext-install -j$(nproc) intl && \
    docker-php-ext-install -j$(nproc) mysqli && \
    docker-php-ext-install -j$(nproc) pdo && \
    docker-php-ext-install -j$(nproc) pdo_mysql && \
    docker-php-ext-install -j$(nproc) opcache

COPY php.ini /usr/local/etc/php/php.ini