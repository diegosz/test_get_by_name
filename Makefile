.PHONY: up produp run prodrun down help

# Run docker-compose dev up with graphjin in compose
up:
	docker-compose -f docker-compose.yml up -d postgres \
	&& docker-compose -f docker-compose.yml run api db:setup \
	&& docker-compose -f docker-compose.yml up -d \
	&& docker-compose -f docker-compose.yml logs -f api

# Run docker-compose dev up with graphjin local
run:
	docker-compose up -d \
	&& while ! nc -z localhost 5432; do sleep 1; echo waiting; done \
	&& sleep 2 \
	&& GO_ENV=dev graphjin db:setup \
	&& GO_ENV=dev graphjin serv

# Run docker-compose down -v
down:
	docker-compose down -v

help:
	@echo
	@echo Commands:
	@echo " make up      - Run docker-compose dev up with graphjin in compose"
	@echo " make run     - Run docker-compose dev up with graphjin local"
	@echo " make down    - Run docker-compose down -v"
	@echo
