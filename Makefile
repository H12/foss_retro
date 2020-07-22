setup:
	docker-compose build &&\
	docker-compose run --rm app mix do deps.get, deps.compile &&\
	docker-compose run --rm app bash -c "cd assets &&\
		npm install &&\
		node node_modules/webpack/bin/webpack.js --mode development"

start:
	docker-compose up -d

stop:
	docker-compose down

console:
	docker-compose run --rm app iex -S mix

format:
	docker-compose run --rm app mix format

update:
	docker-compose run --rm app mix do deps.update --all, deps.compile &&\
	docker-compose run --rm app bash -c "cd assets && npm update"

tests:
	docker-compose run --rm -e "MIX_ENV=test" app mix test
