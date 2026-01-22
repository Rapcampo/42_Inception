FROM debian:oldstable

RUN apt update && apt install -y gosu gettext-base mariadb-server \
	&& apt clean \
	&& mkdir -p /var/run/mysqld /var/lib/mysql \ 
	&& chown -R mysql:mysql /var/run/mysqld /var/lib/mysql

COPY dependancies/script.sh /usr/local/bin/script.sh

RUN chmod +x /usr/local/bin/script.sh

EXPOSE 3306

ENTRYPOINT ["script.sh"]
