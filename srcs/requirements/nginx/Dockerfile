FROM debian:oldstable

RUN apt update && apt install -y nginx openssl && apt clean \
	&& rm -rf /var/lib/apt/lists/*

#ssl cert and key creation
RUN mkdir -p /etc/nginx/ssl/ && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nginx.key \
	-out /etc/nginx/ssl/nginx.crt \
	-subj "/C=PT/ST/Porto/L=Porto/O=42/OU=Dev/CN=rapcampo.42.fr"

EXPOSE 443
# run in the foreground
CMD ["nginx", "-g", "daemon off;"]
