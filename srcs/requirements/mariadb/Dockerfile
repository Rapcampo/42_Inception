FROM Debian:olstable

RUN apt update && apt install -y gettext-base mariadb-server \
	&& apt clean && rm -rf /var/lib/apt/lists/* && mkdir -p /run/mysqld && \
	chown -R mysql:mysql /run/mysqld

COPY deps/script.sh /usr/local/bin/script.sh

RUN chmod +x /usr/local/bin/script.sh

ENTRYPOINT ["script.sh"]
