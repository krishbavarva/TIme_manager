# ----------------------
# Build Stage
# ----------------------
FROM elixir:1.17-alpine AS build

ENV MIX_ENV=prod

# Install build tools
RUN apk add --no-cache build-base git nodejs npm postgresql-client bash

WORKDIR /app

# Install Hex + Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Copy mix files and config
COPY mix.exs mix.lock ./
COPY config config

# Fetch and compile dependencies
RUN mix deps.get --only prod
RUN mix deps.compile

# Copy the rest of the app
COPY . .

# Compile the project and build release
RUN mix compile
RUN mix release

# ----------------------
# Runtime Stage
# ----------------------
FROM elixir:1.17-alpine AS app

# Install runtime dependencies
RUN apk add --no-cache openssl ncurses-libs postgresql-client bash

WORKDIR /app

# Copy release from build stage
COPY --from=build /app/_build/prod/rel/gotham_scheduler ./

# Set environment variables
ENV HOME=/app \
    MIX_ENV=prod \
    PHX_SERVER=true \
    PORT=4000 \
    DB_HOST=db \
    POSTGRES_USER=postgres \
    POSTGRES_PASSWORD=postgres \
    POSTGRES_DB=gotham_scheduler_dev

# Expose port
EXPOSE 4000

# Wait for Postgres, run migrations, then start app
CMD ["sh", "-c", "\
  until pg_isready -h $DB_HOST -p 5432 -U $POSTGRES_USER; do \
    echo 'Waiting for Postgres...'; \
    sleep 2; \
  done; \
  echo 'Postgres is ready!'; \
  bin/gotham_scheduler eval 'GothamScheduler.Release.migrate()'; \
  bin/gotham_scheduler start \
"]
