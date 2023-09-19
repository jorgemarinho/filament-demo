FROM php:8.2.8-fpm-alpine3.18

RUN echo "UTC" > /etc/timezone

RUN apk add openssl bash mysql-client nodejs npm make libpq-dev icu icu-dev

RUN apk add --no-cache php82 \
    php82-common \
    php82-fpm \
    php82-pdo \
    php82-opcache \
    php82-zip \
    php82-phar \
    php82-iconv \
    php82-cli \
    php82-curl \
    php82-openssl \
    php82-mbstring \
    php82-tokenizer \
    php82-fileinfo \
    php82-json \
    php82-xml \
    php82-xmlwriter \
    php82-simplexml \
    php82-dom \
    php82-pdo_mysql \
    php82-pgsql \
    php82-pdo_pgsql \
    php82-tokenizer \
    php82-pecl-redis \
    php82-intl \
    php82-exif

RUN ln -s /usr/bin/php82 /usr/bin/php

RUN docker-php-ext-install pdo pdo_mysql intl exif
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-configure intl
RUN pecl install apcu docker-php-ext-enable apcu pecl clear-cache exif

#composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


WORKDIR /var/www
RUN rm -rf /var/www/html
COPY . /var/www

RUN ln -s public html

#RUN usermod -u 1000 www-data
#USER www-data
EXPOSE 9000

ENTRYPOINT ["php-fpm"]
