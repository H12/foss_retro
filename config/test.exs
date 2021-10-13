use Mix.Config

config :foss_retro, FossRetroWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn
