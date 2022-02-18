import Config

config :logger, level: :info

config :foss_retro, FossRetroWeb.Endpoint, force_ssl: [rewrite_on: [:x_forwarded_proto]]
