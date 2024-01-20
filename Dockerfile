# Usa la imagen oficial de PHP con Apache como servidor web
FROM php:8.1-apache

# Configura el entorno de trabajo
WORKDIR /var/www/html

# Copia los archivos del proyecto al contenedor
COPY . .

# Copia el archivo de configuración de entorno
COPY .env.example .env

# Instala Git y las dependencias necesarias para la extensión ZIP
#RUN apt-get update && \
#    apt-get install -y git zlib1g-dev && \
#    docker-php-ext-install zip

# Instala las extensiones de PHP necesarias para Laravel
RUN docker-php-ext-install pdo pdo_mysql

# Descarga e instala Composer
RUN export COMPOSER_ALLOW_SUPERUSER=1 && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Muestra la información de Composer
RUN export COMPOSER_ALLOW_SUPERUSER=1 && composer --version

# Genera la clave de la aplicación
RUN php artisan key:generate

# Expone el puerto 80 para el servidor web
EXPOSE 80

# Configura el comando para iniciar el servidor Apache
CMD ["apache2-foreground"]
