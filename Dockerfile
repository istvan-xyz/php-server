FROM php:8.1-fpm-bookworm

# PrestaShop's extensions. The build packages go again afterwards; only the
# libraries the extensions link against stay (the official images' pattern).
RUN set -eux; \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get install -y --no-install-recommends libavif-dev libfreetype-dev libicu-dev libjpeg62-turbo-dev libpng-dev libwebp-dev libzip-dev; \
    docker-php-ext-configure gd --with-avif --with-freetype --with-jpeg --with-webp; \
    docker-php-ext-install -j"$(nproc)" gd intl mysqli pdo_mysql sockets zip; \
    apt-mark auto '.*' > /dev/null; \
    apt-mark manual $savedAptMark; \
    find /usr/local -type f \( -executable -o -name '*.so' \) -exec ldd '{}' ';' 2>/dev/null \
        | awk '/=>/ { so = $(NF-1); if (index(so, "/usr/local/") == 1) { next }; gsub("^/(usr/)?", "", so); printf "*%s\n", so }' \
        | sort -u | xargs -r dpkg-query --search | grep -v '^diversion by' | cut -d: -f1 | sort -u | xargs -r apt-mark manual; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/*; \
    ! php -v 2>&1 | grep -i warning; \
    for ext in gd intl mysqli pdo_mysql sockets zip; do php -m | grep -qx "$ext"; done; \
    php -r 'exit(function_exists("imagecreatefromjpeg") && function_exists("imagewebp") && function_exists("imageavif") ? 0 : 1);'

COPY php.ini /usr/local/etc/php/php.ini
