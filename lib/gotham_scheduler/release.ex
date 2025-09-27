defmodule GothamScheduler.Release do
  @app :gotham_scheduler

  def migrate do
    IO.puts("Running migrations...")

    # Ensure Repo is started
    {:ok, _} = Application.ensure_all_started(:ecto_sql)

    repo = GothamScheduler.Repo
    {:ok, _} = repo.__adapter__.storage_up(repo.config)

    Ecto.Migrator.run(repo, :up, all: true)
    IO.puts("Migrations completed")
  end
end
