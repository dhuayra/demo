# Establecer la imagen base
FROM php:8.1-fpm

# Actualizar e instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Establecer el directorio de trabajo en el contenedor
WORKDIR /var/www/html

# Copiar los archivos de la aplicación al contenedor
COPY . .

# Instalar dependencias de Composer
RUN composer install

# Asignar permisos adecuados
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Exponer el puerto 9000
EXPOSE 9000

# Comando para ejecutar el servidor PHP-FPM
CMD ["php-fpm"]
