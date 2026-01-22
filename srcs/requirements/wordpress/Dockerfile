FROM debian:oldstable

RUN apt update && apt install -y php-fpm php-mysql curl unzip \
	default-mysql-client && apt clean \
	&& mkdir -p /run/php

RUN curl -O https://wordpress.org/latest.tar.gz && \
	tar -xzf latest.tar.gz && mkdir -p /var/www/html \
	&& mv wordpress/* /var/www/html \
	&& rm -rf latest.tar.gz wordpress /var/www/html/wp-config.php

RUN chown -R www-data:www-data /var/www/html \
	&& addgroup --gid 984 configgroup \
	&& usermod -aG configgroup www-data

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

COPY dependancies/script.sh /usr/local/bin/script.sh

RUN chmod +x /usr/local/bin/script.sh

ENTRYPOINT [ "script.sh" ]
