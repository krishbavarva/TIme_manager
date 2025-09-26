defmodule GothamScheduler.Work do
  @moduledoc """
  The Work context.
  """

  import Ecto.Query, warn: false
  alias GothamScheduler.Repo

  alias GothamScheduler.Work.WorkingTime
  alias GothamScheduler.Work.Clockin

  # -------------------------------
  # Working Times
  # -------------------------------

  def list_working_times do
    Repo.all(WorkingTime)
  end

  def get_working_time!(id), do: Repo.get!(WorkingTime, id)

  def create_working_time(attrs) do
    %WorkingTime{}
    |> WorkingTime.changeset(attrs)
    |> Repo.insert()
  end

  def update_working_time(%WorkingTime{} = working_time, attrs) do
    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  def delete_working_time(%WorkingTime{} = working_time) do
    Repo.delete(working_time)
  end

  def change_working_time(%WorkingTime{} = working_time, attrs \\ %{}) do
    WorkingTime.changeset(working_time, attrs)
  end

  # -------------------------------
  # Clockins
  # -------------------------------

  def list_clockins do
    Repo.all(Clockin)
  end

  def get_clockin!(id), do: Repo.get!(Clockin, id)

  def create_clockin(attrs) do
    %Clockin{}
    |> Clockin.changeset(attrs)
    |> Repo.insert()
  end

  # ⚡ Custom update to handle in_progress flag
  def update_clockin(%Clockin{} = clockin, attrs) do
    changeset =
      clockin
      |> Clockin.changeset(attrs)
      |> maybe_set_end_time(attrs)

    Repo.update(changeset)
  end

  def delete_clockin(%Clockin{} = clockin) do
    Repo.delete(clockin)
  end

  def change_clockin(%Clockin{} = clockin, attrs \\ %{}) do
    Clockin.changeset(clockin, attrs)
  end

  # -------------------------------
  # Private helpers
  # -------------------------------

  # If someone sets in_progress to false, auto-fill end_time with current UTC timestamp
  defp maybe_set_end_time(changeset, %{"in_progress" => false}) do
    Ecto.Changeset.change(changeset, end_time: DateTime.utc_now())
  end

  defp maybe_set_end_time(changeset, %{:in_progress => false}) do
    Ecto.Changeset.change(changeset, end_time: DateTime.utc_now())
  end

  defp maybe_set_end_time(changeset, _attrs), do: changeset
end
