# Building a Phoenix (Elixir) Release targeting Debian Buster
# (Debian is the OS image used by the official Erlang image)
#
# Note: Build context should be the application root

FROM elixir:1.11

# Install node
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ARG host_url
ENV HOST_URL=$host_url

ARG secret
ENV SECRET_KEY_BASE=$secret

ENV MIX_ENV=prod


# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# build assets
COPY assets/package.json assets/package-lock.json assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets
RUN npm run --prefix ./assets deploy
RUN mix phx.digest

# compile and build release
COPY lib lib
# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix do compile, release app
