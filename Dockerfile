FROM php:8.3-fpm-bookworm

RUN apt update && \
    apt install -fuy supervisor nginx gettext-base unzip wget libpq-dev libzip-dev libfreetype6-dev libjpeg-dev libpng-dev libwebp-dev libicu-dev libcurl4-openssl-dev && \
    pecl install zip sendmail openssl redis excimer && \
    docker-php-ext-enable zip && \
    docker-php-ext-enable redis && \
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-install -j$(nproc) gd && \
    docker-php-ext-install -j$(nproc) curl && \
    docker-php-ext-install -j$(nproc) intl && \
    docker-php-ext-install -j$(nproc) mysqli && \
    docker-php-ext-install -j$(nproc) pdo && \
    docker-php-ext-install -j$(nproc) pdo_pgsql && \
    docker-php-ext-install -j$(nproc) pdo_mysql && \
    docker-php-ext-install -j$(nproc) opcache && \
    docker-php-ext-install -j$(nproc) sockets && \
    php -r 'var_dump(function_exists("imagecreatefromjpeg"));' && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    cd /tmp && \
    wget https://getcomposer.org/installer && \
    php installer --filename=composer --install-dir=/usr/local/bin && \
    rm installer

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

RUN mkdir -p /www

COPY php.ini /usr/local/etc/php/php.ini
COPY www.conf /usr/local/etc/php-fpm.d/www.conf

EXPOSE 80

COPY supervisord.conf /etc/supervisord.conf

COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx-default.conf /etc/nginx/conf.d/default.conf

COPY php-fpm.conf /usr/local/etc/php-fpm.conf

COPY docker-entrypoint.sh /
COPY docker-entrypoint.d /docker-entrypoint.d

# STOPSIGNAL SIGQUIT

WORKDIR /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]