FROM php:7.3-fpm

RUN apt update && \
    apt install -fuy libzip-dev && \
    pecl install zip && \
    docker-php-ext-enable zip