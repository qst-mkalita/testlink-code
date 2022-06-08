FROM php:8.0-cli-bullseye

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=${USER_UID}
ARG LOCALE=en_US.UTF-8
ARG TIME_ZONE=UTC

ENV COMPOSER_ALLOW_SUPERUSER=1
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=${TIME_ZONE}

COPY --from=composer:2.1 /usr/bin/composer /usr/bin/composer
COPY --from=node:16.12 /usr/local/bin /usr/local/bin

RUN apt-get update \
    && apt-get install -y bash-completion curl dnsutils git imagemagick jq locales mariadb-client postgresql-client rsync sqlite3 tree unzip vim wget zip libc-client-dev libfreetype6-dev libjpeg62-turbo-dev libkrb5-dev libmagickwand-dev libonig-dev libpng-dev libpq-dev libsqlite3-dev libxslt-dev libzip-dev \
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

# Set the locale
RUN sed -i -E "s/# (${LOCALE})/\1/" /etc/locale.gen \
    && locale-gen ${LOCALE} \
    && dpkg-reconfigure locales \
    && update-locale LANG=${LOCALE}

# Set the timezone
RUN ln -snf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime && echo ${TIME_ZONE} > /etc/timezone

# Create the user
RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
    && apt-get update \
    && apt-get install -y sudo \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}