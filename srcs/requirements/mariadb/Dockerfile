FROM debian:oldstable

RUN apt update && apt install -y gosu gettext-base mariadb-server \
	&& apt clean && rm -rf /var/lib/apt/lists/* \
	&& mkdir -p /var/run/mysqld \
	&& chown -R mysql:mysql /var/run/mysqld

COPY dependancies/script.sh /usr/local/bin/script.sh

RUN chmod +x /usr/local/bin/script.sh

EXPOSE 3306

ENTRYPOINT ["script.sh"]
