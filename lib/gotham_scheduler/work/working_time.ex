defmodule GothamScheduler.Work.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  alias GothamScheduler.Accounts.User
  alias GothamScheduler.Work.Clockin

  schema "working_times" do
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime

    # Proper association to user
    belongs_to :user, User

    # Clockins associated with this working time
    has_many :clockins, Clockin

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:start_time, :end_time, :user_id])
    |> validate_required([:start_time, :end_time, :user_id])
  end
end
