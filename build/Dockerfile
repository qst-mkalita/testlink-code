FROM php:7.4-fpm

ARG USER_UID=1000
ARG USER_GID=${USER_UID}

ENV SMTP_HOST='localhost'
ENV SMTP_PORT='25'
ENV SMTP_PROTOCOL=''
ENV SMTP_USERNAME=''
ENV SMTP_PASSWORD=''
ENV MAIL_PRIORITY=5
ENV MAIL_METHOD=PHPMAILER_METHOD_SMTP

# Some mail services not working if below values are not set.
ENV MAIL_ADMIN=''
ENV MAIL_FROM=''
ENV MAIL_RETURN=''

ENV COMPANY_NAME='<Your company name here>'

# PHP_CPPFLAGS are used by the docker-php-ext-* scripts
ENV PHP_CPPFLAGS="$PHP_CPPFLAGS -std=c++11"

# Installing nginx
RUN apt-get update -y \
    && apt-get install -y nginx

# Installing PHP extensions
RUN apt-get update -y && apt-get install -y libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libldap2-dev \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) mysqli \
    && docker-php-ext-install ldap \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install opcache

RUN { \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=2'; \
    echo 'opcache.fast_shutdown=1'; \
    echo 'opcache.enable_cli=1'; \
} > /usr/local/etc/php/conf.d/php-opcache-cfg.ini

RUN { \
    echo 'post_max_size=520M'; \
    echo 'upload_max_filesize=512M'; \
    echo 'max_execution_time=120'; \
    echo 'memory_limit=256M'; \
} > /usr/local/etc/php/php.ini

RUN groupmod -o -g ${USER_GID} www-data \
    && usermod -o -u ${USER_UID} -g www-data www-data

COPY ./build/nginx-site.conf /etc/nginx/sites-enabled/default
COPY ./build/custom_config.sh ./build/docker-testlink-entrypoint /usr/local/bin/
RUN chmod +x /usr/local/bin/*

RUN mkdir -p /var/testlink/logs \
    && mkdir -p /var/testlink/upload_area \
    && chown -R www-data /var/testlink
COPY . /var/www/testlink
RUN chown -R www-data /var/www/testlink

WORKDIR /var/www/testlink

ENTRYPOINT [ "docker-testlink-entrypoint" ]