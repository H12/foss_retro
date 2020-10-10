import Config

secret_key_base = System.fetch_env!("SECRET_KEY_BASE")
application_port = System.fetch_env!("APP_PORT")

config :easy_retro, EasyRetroWeb.Endpoint,
  http: [
    port: String.to_integer(application_port),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base
