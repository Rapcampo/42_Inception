all: up

up:
	mkdir -p /home/rapcampo/data/mariadb
	mkdir -p /home/rapcampo/data/wordpress
	docker compose -f ./srcs/docker-compose.yml up -d --build

down:
	docker compose -f ./srcs/docker-compose.yml down

re: 
	docker compose -f ./srcs/docker-compose.yml up -d --build --force-recreate

clean:
	docker compose -f ./srcs/docker-compose.yml down -v 

fclean:
	docker stop $$(docker ps -qa)
	docker rm $$(docker ps -qa)
	docker rmi -f $$(docker images -qa)
	docker volume rm $$(docker volume ls -q)
	docker system prune -a
	sudo rm -rf /home/rapcampo/data

log_mariadb:
	docker compose -f ./srcs/docker-compose.yml logs -f mariadb

log_wordpress:
	docker compose -f ./srcs/docker-compose.yml logs -f wordpress

log_nginx:
	docker compose -f ./srcs/docker-compose.yml logs -f nginx

database:
	docker exec -it mariadb sh -lc 'mariadb -uroot -p"$(cat /run/secrets/db_root_pass)" -e "SHOW DATABASES; SELECT user,host FROM mysql.user;"'
tables:
	docker exec -it mariadb sh -lc 'mariadb -uroot -p"$(cat /run/secrets/db_root_pass)" -e "SHOW DATABASES; USE wordpress; SHOW TABLES;"'

.PHONY: all up down re clean fclean
