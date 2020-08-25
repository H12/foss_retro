FROM elixir:1.10

RUN apt-get update
RUN apt-get install --yes build-essential inotify-tools

# Set working directory
WORKDIR /app

# Install hex and rebar
RUN mix local.hex --force &&\
      mix local.rebar --force

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - &&\
      apt-get install --yes nodejs

# Set the run command
CMD ["./run.sh"]
