#!/bin/sh

echo "Installing Elixir dependencies...\n"
mix deps.get
mix deps.compile

echo "Installing Node dependencies...\n"
cd assets && npm install
cd ..

echo "Launching Phoenix server...\n"
mix phx.server
