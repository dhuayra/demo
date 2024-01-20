# Usa la imagen oficial de PHP con Apache como servidor web
FROM php:8.1-apache

# Instala las extensiones de PHP necesarias para Laravel
RUN docker-php-ext-install pdo pdo_mysql

# Configura el entorno de trabajo
WORKDIR /var/www/html

# Copia los archivos del proyecto al contenedor
COPY . .

# Copia el archivo de configuración de entorno
COPY .env.example .env

# Genera la clave de la aplicación
RUN php artisan key:generate

# Instala las dependencias de Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-interaction --no-scripts --no-suggest --optimize-autoloader

# Cambia los permisos para evitar problemas de escritura
RUN chown -R www-data:www-data storage bootstrap/cache

# Expone el puerto 80 para el servidor web
EXPOSE 80

# Comando para iniciar el servidor web de Laravel
CMD ["apache2-foreground"]
