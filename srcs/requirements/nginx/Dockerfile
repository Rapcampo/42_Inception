FROM debian:oldstable

RUN apt update && apt install -y nginx openssl \
	&& apt clean && mkdir -p /etc/nginx/ssl /run/nginx /var/log/nginx \
	&& openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nginx.key \
	-out /etc/nginx/ssl/nginx.crt \
	-subj "/C=PT/ST=Porto/L=Porto/O=42inception/OU=Dev/CN=rapcampo.42.fr"

#COPY dependancies/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
