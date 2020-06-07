FROM elixir:1.10.3
MAINTAINER Henry Firth

ENV PHX_VERSION 1.5.3
ENV NODE_MAJOR 12

# Create an app directory to store our files in
ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Install inotify-tools for file watching
RUN apt-get update &&\
    apt-get -y install inotify-tools

# Install Hex
RUN mix local.hex --force &&\
    mix local.rebar --force

# Install Phoenix
RUN mix archive.install hex phx_new $PHX_VERSION --force

# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash - &&\
    apt-get install -y nodejs
