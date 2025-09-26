defmodule GothamScheduler.Reports.ChartManager do
  import Ecto.Query
  alias GothamScheduler.Repo
  alias GothamScheduler.Accounts.User
  alias GothamScheduler.Work.Clockin
  alias GothamScheduler.Work.WorkingTime

  # total worked hours per user (only completed sessions)
  def total_hours_per_user do
    query =
      from c in Clockin,
        where: not is_nil(c.end_time),
        join: u in User, on: u.id == c.user_id,
        group_by: [c.user_id, u.firstname, u.lastname],
        select: %{
          user_id: c.user_id,
          user_name: fragment("? || ' ' || ?", u.firstname, u.lastname),
          hours: sum(fragment("EXTRACT(EPOCH FROM (? - ?)) / 3600", c.end_time, c.start_time))
        }

    Repo.all(query)
  end

  # hours per day for a given user
  def hours_by_user(user_id) do
    query =
      from c in Clockin,
        where: c.user_id == ^user_id and not is_nil(c.end_time),
        group_by: fragment("DATE(?)", c.start_time),
        order_by: fragment("DATE(?)", c.start_time),
        select: %{
          date: fragment("DATE(?)", c.start_time),
          hours: sum(fragment("EXTRACT(EPOCH FROM (? - ?)) / 3600", c.end_time, c.start_time))
        }

    Repo.all(query)
  end

  # sessions that join scheduled shifts and actual clockins
  def sessions_for_user(user_id) do
    query =
      from w in WorkingTime,
        left_join: c in Clockin, on: c.working_time_id == w.id,
        where: w.user_id == ^user_id,
        order_by: w.start_time,
        select: %{
          scheduled_start: w.start_time,
          scheduled_end: w.end_time,
          actual_start: c.start_time,
          actual_end: c.end_time
        }

    Repo.all(query)
  end
end
