all: up

up:
	mkdir -p /home/rapcampo/data/mariadb
	mkdir -p /home/rapcampo/data/wordpress
	docker compose -f ./srcs/docker-compose.yml up -d --build

down:
	docker compose -f ./srcs/docker-compose.yml down

re: clean up

clean:
	docker compose -f ./srcs/docker-compose.yml down -v

fclean:
	docker stop $$(docker ps -qa)
	docker rm $$(docker ps -qa)
	docker rmi -f $$(docker images -qa)
	docker volume rm $$(docker volume ls -q)
	docker system prune -a
	sudo rm -rf /home/rapcampo/data

.PHONY: all up down re clean fclean
