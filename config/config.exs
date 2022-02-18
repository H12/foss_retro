import Config

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :foss_retro, FossRetroWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: FossRetroWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: FossRetro.PubSub,
  live_view: [signing_salt: "ajrnAhgf"]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
