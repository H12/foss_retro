# EasyRetro

This is a simple, real-time retro board built with Phoenix LiveView and OTP.

## Getting Started

Below are the setup steps for local development. You can choose whether you'd like to run the app containerized with Docker, or natively on your local machine.

### With Docker

You can use `docker-compose` commands directly, but this project has a Makefile for your convenience.

#### Requirements

- `docker`
- `docker-compose`

#### Optional Goodies

- [Docker Desktop](https://www.docker.com/products/docker-desktop)

#### Commands

##### `make` or `make setup`

Does the necessary first-time docker setup

##### `make start`

Starts the project on port 4000

##### `make stop`

Stops the project

##### `make console`

Starts an interactive Elixir shell

##### `make format`

Auto-formats your Elixir code

##### `make tests`

Runs the project's test suite

##### `make rebuild`

Wipes away any installed dependencies or compiled artifacts and rebuilds the project (this is the one that fixes cryptic OTP and node-sass errors)

#### Dependencies

As this is a phoenix project, Elixir dependencies are managed in `mix.exs` and JavaScript dependencies in `assets/package.json`.

If you find yourself updating these dependencies, be sure to update your docker images by running `make` or `make setup`.

### Natively

To run this project natively, you'll need to have a few dependencies set up on your local machine. You can choose whatever method of installation you're most comfortable with; the [Phoenix Framework docs](https://hexdocs.pm/phoenix/installation.html#content) provide a good introduction, but you could also use a version manager like [`asdf`](https://asdf-vm.com/#/).

#### Requirements

- Erlang `22.2.x`
- Elixir `1.10.x`
- Phoenix `1.5.x`
- NodeJS `12.x.x`

#### Commands

##### `mix setup`

Installs the project's dependences

##### `mix phx.server`

Starts the Phoenix server

##### `iex -S mix`

Starts an interactive Elixir shell

##### `mix format`

Auto-formats you're Elixir code

##### `MIX_ENV=test mix test`

Runs the project's test suite

### Hooray!

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
- Deployment: https://hexdocs.pm/phoenix/deployment.html).
