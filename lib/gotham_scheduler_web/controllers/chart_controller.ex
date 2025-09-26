defmodule GothamSchedulerWeb.ChartController do
  use GothamSchedulerWeb, :controller
  alias GothamScheduler.Reports.ChartManager

  # Returns total worked hours per user
  def total_hours(conn, _params) do
    json(conn, ChartManager.total_hours_per_user())
  end

  # Returns worked hours for a specific user
  def hours_by_user(conn, %{"user_id" => user_id}) do
    data = ChartManager.hours_by_user(String.to_integer(user_id))
    json(conn, data)
  end

  # Returns sessions (scheduled + actual) for a specific user
  def sessions_by_user(conn, %{"user_id" => user_id}) do
    data = ChartManager.sessions_for_user(String.to_integer(user_id))
    json(conn, data)
  end
end
