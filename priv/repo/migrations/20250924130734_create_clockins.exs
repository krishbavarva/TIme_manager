defmodule StaffScheduler.Repo.Migrations.CreateClockins do
  use Ecto.Migration

  def change do
  create table(:clockins) do
    add :user_id, references(:users, on_delete: :delete_all), null: false
    add :working_time_id, references(:working_times, on_delete: :nilify_all)
    add :start_time, :utc_datetime_usec
    add :end_time, :utc_datetime_usec
    add :in_progress, :boolean, default: false, null: false

    timestamps(type: :utc_datetime_usec)
  end

  create index(:clockins, [:user_id])
  create index(:clockins, [:working_time_id])

  execute("""
  CREATE UNIQUE INDEX clockins_user_active_idx ON clockins (user_id) WHERE in_progress = TRUE;
  """)
end

end
