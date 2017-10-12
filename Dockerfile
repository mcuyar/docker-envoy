FROM alpine:latest
MAINTAINER Matthew Cuyar <matt@enctypeapparel.com>

#----------------------------------------------------
# Base Alpine edge image w/s6 Overlay, Nginx and PHP7
#----------------------------------------------------

##/
 # Install PHP
 #/
RUN apk --no-cache --update --repository=http://dl-4.alpinelinux.org/alpine/edge/testing add \
    bash \
    curl \
    git \
    openssh \
    php7 \
    php7-fpm \
    php7-xml \
    php7-pgsql \
    php7-pdo_pgsql \
    php7-mysqli \
    php7-pdo_mysql \
    php7-mcrypt \
    php7-opcache \
    php7-gd \
    php7-curl \
    php7-json \
    php7-phar \
    php7-openssl \
    php7-ctype \
    php7-mbstring \
    php7-zip \
    php7-dom \
    php7-pcntl \
    php7-posix \
    php7-session \
    php7-zlib \
    php7-tokenizer \
    php7-simplexml \
    php7-xmlwriter \
    php7-fileinfo

##/
 # Install composer & Envoy
 #/
ENV COMPOSER_HOME=/composer
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH $COMPOSER_HOME/vendor/bin:$PATH

RUN mkdir /composer \
    && curl -sS https://getcomposer.org/installer | php \
    && mkdir -p /opt/composer \
    && mv composer.phar /usr/bin/composer \
    && composer global require laravel/envoy

##/
 # Set WORKDIR
 #/
RUN mkdir /envoy

WORKDIR /envoy

##/
 # Copy files
 #/
COPY rootfs /

##/
 # Set the s6 overlay init
 #/
ENTRYPOINT ["/entrypoint/envoy"]