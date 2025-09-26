defmodule GothamSchedulerWeb.ClockinJSON do
  alias GothamScheduler.Work.Clockin

  @doc """
  Renders a list of clockins.
  """
  def index(%{clockins: clockins}) do
    %{data: for(clockin <- clockins, do: data(clockin))}
  end

  @doc """
  Renders a single clockin.
  """
  def show(%{clockin: clockin}) do
    %{data: data(clockin)}
  end

  defp data(%Clockin{} = clockin) do
    %{
      id: clockin.id,
      start_time: clockin.start_time,
      end_time: clockin.end_time,
      in_progress: clockin.in_progress
    }
  end
end
