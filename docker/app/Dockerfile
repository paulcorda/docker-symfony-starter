# #########################
# ###### BUILD STAGE ######
# #########################
FROM composer:1 AS build
WORKDIR /app

# Install global package for paralel builds
RUN composer global require "hirak/prestissimo:^0.3" \
        --prefer-dist \
        --no-progress \
        --no-suggest \
        --optimize-autoloader \
        --classmap-authoritative \
    && composer clear-cache

# Copy over dependency definitions, application files and install
COPY composer* symfony.lock ./
RUN composer install \
    --ignore-platform-reqs \
    --no-interaction \
    --no-scripts \
    --prefer-dist

# #########################
# ####### RUN STAGE #######
# #########################
FROM php:7.2-fpm-alpine AS run
WORKDIR /app

# Copy over composer and dependencies from the build stage
ENV COMPOSER_ALLOW_SUPERUSER 1
COPY --from=build /usr/bin/composer /usr/bin/composer
COPY --from=build /app/vendor/ ./vendor/

# General PHP settings for the app
COPY ./docker/app/config/php.ini /usr/local/etc/php/php.ini

# Install runtime PHP dependencies
RUN apk --update --no-cache add \
        icu-dev \
        libzip-dev \
        zlib-dev \
    && docker-php-ext-install \
        intl \
        opcache \
        pdo_mysql \
        zip \
    && docker-php-ext-enable opcache \
    && rm -rf /var/cache/apk/*

# ##########################
# ####### PROD STAGE #######
# ##########################
FROM run AS prod
WORKDIR /app

# Copy application, build optimized autoload and warm cache
COPY . ./
RUN composer dump-autoload --classmap-authoritative --optimize \
    && php bin/console cache:warmup

# #########################
# ####### DEV STAGE #######
# #########################
FROM run AS dev
WORKDIR /app

# Install debugging dependencies
RUN apk --update --no-cache add $PHPIZE_DEPS \
    && pecl install -f xdebug \
    && docker-php-ext-enable xdebug \
    && apk --purge del $PHPIZE_DEPS \
    && rm -rf /var/cache/apk/*

COPY ./docker/app/config/debug.ini /usr/local/etc/php/conf.d/90-debug.ini

# Speed up runtime composer with the previously built cache
COPY --from=build /tmp/cache/ /tmp/cache/

# Run the dev init script
COPY ./docker/app/dev.sh /usr/local/bin/init
RUN ["chmod", "+x", "/usr/local/bin/init"]
ENTRYPOINT ["init"]

# #########################
# ######## DEFAULT ########
# #########################
FROM prod
