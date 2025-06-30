FROM debian:oldstable

RUN apt update && \
	apt install -y php-fpm php-mysql curl unzip default-mysql-clienta && \
	apt clean && rm -rf /var/lib/apt/lists/* && mkdir -p /run/php

RUN 
