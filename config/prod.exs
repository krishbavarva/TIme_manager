import Config

# Configure Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Req

# Disable Swoosh Local Memory Storage
config :swoosh, local: false

# Do not print debug messages in production
config :logger, level: :info

# Configure your Phoenix endpoint for production
config :gotham_scheduler, GothamSchedulerWeb.Endpoint,
  url: [host: System.get_env("PHX_HOST") || "example.com", port: 443],
  http: [
    ip: {0, 0, 0, 0}, # binds to all interfaces inside Docker
    port: String.to_integer(System.get_env("PORT") || "4000")
  ],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  server: true
