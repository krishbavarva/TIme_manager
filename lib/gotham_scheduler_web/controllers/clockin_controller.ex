defmodule GothamSchedulerWeb.ClockinController do
  use GothamSchedulerWeb, :controller

  alias GothamScheduler.Work
  alias GothamScheduler.Work.Clockin

  action_fallback GothamSchedulerWeb.FallbackController

  # -------------------------------
  # Standard CRUD Actions
  # -------------------------------

  def index(conn, _params) do
    clockins = Work.list_clockins()
    render(conn, :index, clockins: clockins)
  end

  def show(conn, %{"id" => id}) do
    clockin = Work.get_clockin!(id)
    render(conn, :show, clockin: clockin)
  end

  def create(conn, %{"clockin" => clockin_params}) do
    with {:ok, %Clockin{} = clockin} <- Work.create_clockin(clockin_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clockins/#{clockin.id}")
      |> render(:show, clockin: clockin)
    end
  end

  def update(conn, %{"id" => id, "clockin" => clockin_params}) do
    clockin = Work.get_clockin!(id)

    case Work.update_clockin(clockin, clockin_params) do
      {:ok, clockin} -> render(conn, :show, clockin: clockin)
      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Cannot update clockin", details: changeset})
    end
  end

  def delete(conn, %{"id" => id}) do
    clockin = Work.get_clockin!(id)

    with {:ok, %Clockin{}} <- Work.delete_clockin(clockin) do
      send_resp(conn, :no_content, "")
    end
  end

  # -------------------------------
  # Convenience Endpoints: Start / Stop
  # -------------------------------

  # Start a clockin (requires user_id, working_time_id, and start_time in request)
  def start(conn, %{"user_id" => user_id, "working_time_id" => working_time_id, "start_time" => start_time}) do
    attrs = %{
      "user_id" => user_id,
      "working_time_id" => working_time_id,
      "start_time" => start_time,
      "in_progress" => true
    }

    case Work.start_clockin(attrs) do
      {:ok, clockin} ->
        conn
        |> put_status(:created)
        |> json(clockin)

      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: reason})
    end
  end

  # Stop a clockin (requires id and end_time in request)
  def stop(conn, %{"id" => id, "end_time" => end_time}) do
    clockin = Work.get_clockin!(id)

    attrs = %{
      "in_progress" => false,
      "end_time" => end_time
    }

    case Work.update_clockin(clockin, attrs) do
      {:ok, clockin} ->
        json(conn, clockin)

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Cannot stop clockin", details: changeset})
    end
  end

  # -------------------------------
  # Helpers (removed time truncation - times are handled as-is)
  # -------------------------------
end
