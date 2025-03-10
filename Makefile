
NAME = inception
COMPOSE_FILE = src/docker-compose.yml
ENV_FILE = src/.env
VOLUME = /Users/chorst/Desktop/Inception

all: up

up: build
	docker compose -p $(NAME) -f $(COMPOSE_FILE) --env-file $(ENV_FILE) up -d
build:
	mkdir -p /home/chorst/data/mariadb
	mkdir -p /home/chorst/data/wordpress
	docker compose -p $(NAME) -f $(COMPOSE_FILE) --env-file $(ENV_FILE) build --no-cache

stop:
	docker compose -p $(NAME) -f $(COMPOSE_FILE) stop

down:
	docker compose -p $(NAME) -f $(COMPOSE_FILE) down

clean:
	docker compose -p $(NAME) -f $(COMPOSE_FILE) down

fclean: clean
	docker compose -f $(COMPOSE_FILE) down --volumes --remove-orphans --rmi all
	docker image prune -a -f

re: fclean up
