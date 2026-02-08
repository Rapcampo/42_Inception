FROM debian:oldstable

RUN apt-get update && apt-get install -y --no-install-recommends \
	gosu mariadb-server \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* \
	&& mkdir -p /run/mysqld /var/lib/mysql \
	&& chown -R mysql:mysql /run/mysqld /var/lib/mysql

COPY tools/script.sh /usr/local/bin/script.sh

RUN chmod +x /usr/local/bin/script.sh

EXPOSE 3306

ENTRYPOINT ["script.sh"]
