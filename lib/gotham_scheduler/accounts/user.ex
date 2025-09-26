defmodule GothamScheduler.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :firstname, :string
    field :lastname, :string
    field :username, :string
    field :email, :string
    field :password, :string

    has_many :working_times, GothamScheduler.Work.WorkingTime
    has_many :clockins, GothamScheduler.Work.Clockin


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:firstname, :lastname, :username, :email, :password])
    |> validate_required([:firstname, :lastname, :username, :email, :password])
  end
end
