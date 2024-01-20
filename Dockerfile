# Usa la imagen oficial de PHP con Apache como servidor web
FROM php:8.1-apache

# Instala Git y las dependencias necesarias para la extensión ZIP
#RUN apt-get update && \
#    apt-get install -y git zlib1g-dev && \
#    docker-php-ext-install zip

# Instala las extensiones de PHP necesarias para Laravel
RUN docker-php-ext-install pdo pdo_mysql

# Configura el entorno de trabajo
WORKDIR /var/www/html

# Copia los archivos del proyecto al contenedor
COPY . .

# Copia el archivo de configuración de entorno
COPY .env.example .env

# Instala las dependencias de Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-interaction --no-scripts --no-suggest --optimize-autoloader

# Cambia los permisos para evitar problemas de escritura
#RUN chown -R www-data:www-data storage bootstrap/cache

# Genera la clave de la aplicación
RUN php artisan key:generate

# Expone el puerto 80 para el servidor web
EXPOSE 80

# Configura el comando para iniciar el servidor Apache
CMD ["apache2-foreground"]
