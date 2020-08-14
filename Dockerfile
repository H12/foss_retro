FROM elixir:1.10-alpine
MAINTAINER Henry Firth

RUN apk update
RUN apk upgrade --no-cache
RUN apk add nodejs=12.15.0-r1 nodejs-npm=12.15.0-r1
RUN apk add inotify-tools=3.20.1-r1
RUN mix local.rebar --force
RUN mix local.hex --force

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

CMD ["mix", "phx.server"]
