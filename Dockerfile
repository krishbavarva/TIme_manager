# Use official Elixir image with Erlang & Node.js
FROM elixir:1.17-alpine AS build

# Set environment
ENV MIX_ENV=prod

# Install build tools
RUN apk add --no-cache build-base git nodejs npm postgresql-client

# Set working directory
WORKDIR /app

# Install Hex + Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Copy mix files and install deps
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only prod
RUN mix deps.compile

# Copy the rest of the app
COPY . .

# Compile and build release
RUN mix compile
RUN mix release

# ----------------------
# Runtime container
# ----------------------
FROM elixir:1.17-alpine AS app

# Install runtime deps
RUN apk add --no-cache openssl ncurses-libs postgresql-client

WORKDIR /app

# Copy release from build stage
COPY --from=build /app/_build/prod/rel/gotham_scheduler ./

# Set environment
ENV HOME=/app \
    MIX_ENV=prod \
    PHX_SERVER=true \
    PORT=4000

# Expose port
EXPOSE 4000

# Start the app
CMD ["bin/gotham_scheduler", "start"]
