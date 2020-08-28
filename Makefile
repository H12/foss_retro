setup:
	docker-compose build

start:
	docker-compose up -d

stop:
	docker-compose down

console:
	docker-compose run --rm app iex -S mix

format:
	docker-compose run --rm app mix format

tests:
	docker-compose run --rm -e "MIX_ENV=test" app mix test

rebuild:
	rm -rf _build cover deps doc /assets/node_modules /priv/static && \
	docker-compose build
