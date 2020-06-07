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

tests:
	MIX_ENV=test mix coveralls

coverage:
	MIX_ENV=test mix coveralls.html &&\
	open cover/excoveralls.html
