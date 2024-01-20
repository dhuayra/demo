# Usa la imagen oficial de PHP con Apache como servidor web
FROM php:8.1-apache

# Configura el entorno de trabajo
WORKDIR /var/www/html

# Instala las dependencias necesarias para Composer
RUN apt-get update && \
    apt-get install -y unzip && \
    rm -rf /var/lib/apt/lists/*

# Descarga e instala Composer
RUN export COMPOSER_ALLOW_SUPERUSER=1 && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instala las dependencias de Composer
RUN export COMPOSER_ALLOW_SUPERUSER=1 && \
    composer install --no-interaction --no-scripts --optimize-autoloader

# Copia los archivos del proyecto al contenedor
COPY . .

# Copia el archivo de configuración de entorno
COPY .env.example .env

# Genera la clave de la aplicación
RUN php artisan key:generate

# Cambia los permisos para evitar problemas de escritura
# RUN chown -R www-data:www-data storage bootstrap/cache

# Expone el puerto 80 para el servidor web
EXPOSE 80

# Configura el comando para iniciar el servidor Apache
CMD ["apache2-foreground"]
