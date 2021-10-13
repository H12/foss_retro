import Config

if config_env() == :prod do
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  signing_salt =
    System.get_env("SIGNING_SALT") ||
      raise """
      environment variable SIGNING_SALT is missing.
      You can generate one by calling: mix phx.gen.secret 32
      """

  app_url =
    System.get_env("APP_URL") ||
      raise "APP_URL not available"

  config :foss_retro, FossRetroWeb.Endpoint,
    server: true,
    secret_key_base: secret_key_base,
    live_view: [signing_salt: signing_salt],
    pubsub_server: FossRetro.PubSub,
    url: [host: app_url, port: 80],
    http: [
      port: String.to_integer(System.get_env("PORT") || "4000"),
      transport_options: [socket_opts: [:inet6]]
    ]
end
