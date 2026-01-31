FROM debian:oldstable

RUN apt-get update && apt-get install -y --no-install-recommends nginx openssl \
	&& apt-get clean  && rm -rf /var/lib/apt/lists/* \
	&& mkdir -p /etc/nginx/ssl /run/nginx /var/log/nginx \
	&& openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nginx.key \
	-out /etc/nginx/ssl/nginx.crt \
	-subj "/C=PT/ST=Porto/L=Porto/O=42inception/OU=Dev/CN=rapcampo.42.fr"

#COPY dependancies/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

# run in the foreground
CMD ["nginx", "-g", "daemon off;"]
