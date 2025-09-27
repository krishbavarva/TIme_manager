import Config

# Configure Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Req

# Disable Swoosh Local Memory Storage
config :swoosh, local: false

# Do not print debug messages in production
config :logger, level: :info

# Configure your database for production
config :gotham_scheduler, GothamScheduler.Repo,
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "postgres",
  database: System.get_env("POSTGRES_DB") || "gotham_scheduler_dev",
  hostname: System.get_env("DB_HOST") || "localhost",
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

# Configure your Phoenix endpoint for production
config :gotham_scheduler, GothamSchedulerWeb.Endpoint,
  url: [host: System.get_env("PHX_HOST") || "example.com", port: 443],
  http: [
    ip: {0, 0, 0, 0}, # binds to all interfaces inside Docker
    port: String.to_integer(System.get_env("PORT") || "4000")
  ],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  server: true
