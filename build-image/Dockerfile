FROM php:8.2-alpine

RUN apk add --no-cache nginx

COPY index.php /var/www/html/index.php

EXPOSE 80

COPY nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]
