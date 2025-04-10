FROM php:8.4-fpm

WORKDIR /www
RUN apt-get update && apt-get install -y \
        git \
        zip \
        unzip \        
        zlib1g-dev \
        libzip-dev \
        libfreetype-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
    &&  docker-php-ext-install pdo_mysql

RUN docker-php-ext-install zip gd

RUN docker-php-ext-configure pcntl --enable-pcntl \
  && docker-php-ext-install \
    pcntl

    RUN pecl install redis \    
    # Redis is installed, enable it
     && docker-php-ext-enable redis zip \
     && docker-php-ext-configure gd --with-freetype --with-jpeg
 
#  RUN pecl install xdebug-3.0.3 && docker-php-ext-enable xdebug
 
 
 COPY ./ /www
#  COPY 90-xdebug.ini "${PHP_INI_DIR}/conf.d"
 RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
 COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
 
 # RUN php artisan migrate
 RUN composer install
 EXPOSE 9000