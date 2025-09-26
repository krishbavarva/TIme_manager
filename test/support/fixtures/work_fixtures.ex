defmodule GothamScheduler.WorkFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GothamScheduler.Work` context.
  """

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end_time: ~U[2025-09-23 13:05:00Z],
        start_time: ~U[2025-09-23 13:05:00Z]
      })
      |> GothamScheduler.Work.create_working_time()

    working_time
  end

  @doc """
  Generate a clockin.
  """
  def clockin_fixture(attrs \\ %{}) do
    {:ok, clockin} =
      attrs
      |> Enum.into(%{
        end_time: ~U[2025-09-23 13:07:00Z],
        in_progress: true,
        start_time: ~U[2025-09-23 13:07:00Z]
      })
      |> GothamScheduler.Work.create_clockin()

    clockin
  end
end
