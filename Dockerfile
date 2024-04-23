FROM alpine:latest

RUN apk --no-cache add nginx php8.2 php8.2-fpm

# Copy nginx and PHP configuration files
# COPY nginx.conf /etc/nginx/nginx.conf
# COPY php-fpm.conf /etc/php8/php-fpm.conf

WORKDIR /var/www/html

COPY index.php .

EXPOSE 80

CMD ["php-fpm", "-F"]
