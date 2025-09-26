defmodule GothamScheduler.Work.Clockin do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clockins" do
    field :start_time, :utc_datetime_usec
    field :end_time, :utc_datetime_usec
    field :in_progress, :boolean, default: false

    belongs_to :user, GothamScheduler.Accounts.User
    belongs_to :working_time, GothamScheduler.Work.WorkingTime

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(clockin, attrs) do
    clockin
    |> cast(attrs, [:user_id, :working_time_id, :start_time, :end_time, :in_progress])
    |> validate_required([:user_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:working_time_id)
  end
end
