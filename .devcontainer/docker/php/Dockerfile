FROM php:7.4-fpm

ARG USER_UID=1000
ARG USER_GID=${USER_UID}

RUN apt-get update \
    && apt-get install -y libc-client-dev libfreetype6-dev libjpeg62-turbo-dev libkrb5-dev libmagickwand-dev libonig-dev libpng-dev libpq-dev libsqlite3-dev libxslt-dev libzip-dev sqlite3 zip \
    && pecl install imagick xdebug-3.1.1 \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-enable imagick xdebug \
    && docker-php-ext-install bcmath gd imap intl pdo_mysql mysqli xml zip

# Configure LDAP.
RUN apt-get update \
    && apt-get install libldap2-dev -y \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap

# Create the user
RUN groupmod -o -g ${USER_GID} www-data \
    && usermod -o -u ${USER_UID} -g www-data www-data