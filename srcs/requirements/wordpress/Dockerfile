FROM debian:oldstable

RUN apt update && apt install -y php-fpm php-mysql curl unzip \
	default-mysql-client && apt clean && rm -rf /var/lib/apt/lists/* \
	&& mkdir -p /run/php

RUN curl -O https://wordpress.org/latest.tar.gz && \
	tar -xzf latest.tar.gz && mkdir -p /var/www/html \
	&& mv wordpress/* /var/www/html \
	&& rm -rf latest.tar.gz wordpress /var/www/html/wp-config.php \
	&& sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' etc/php/*/fpm/pool.d/www.conf \
	&& sed -i 's|^php_admin_value[memory_limit]= .*|php_admin_value[memory_limit] = 512M|' etc/php/*/fpm/pool.d/www.conf

RUN chown -R www-data:www-data /var/www/html \
	&& addgroup --gid 984 configgroup \
	&& usermod -aG configgroup www-data

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html

COPY dependancies/script.sh /usr/local/bin/script.sh

RUN chmod +x /usr/local/bin/script.sh

EXPOSE 9000

ENTRYPOINT [ "script.sh" ]
