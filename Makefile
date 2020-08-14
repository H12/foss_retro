setup:
	docker-compose build

start:
	docker-compose up -d

stop:
	docker-compose down

console:
	docker-compose run --rm phoenix iex -S mix

format:
	docker-compose run --rm phoenix mix format

update:
	docker-compose run --rm phoenix mix do deps.update --all, deps.compile &&\
	docker-compose run --rm phoenix bash -c "cd assets && npm update"

tests:
	docker-compose run --rm -e "MIX_ENV=test" phoenix mix test
