defmodule GothamSchedulerWeb.ClockinControllerTest do
  use GothamSchedulerWeb.ConnCase

  import GothamScheduler.WorkFixtures
  alias GothamScheduler.Work.Clockin

  @create_attrs %{
    start_time: ~U[2025-09-23 13:07:00Z],
    end_time: ~U[2025-09-23 13:07:00Z],
    in_progress: true
  }
  @update_attrs %{
    start_time: ~U[2025-09-24 13:07:00Z],
    end_time: ~U[2025-09-24 13:07:00Z],
    in_progress: false
  }
  @invalid_attrs %{start_time: nil, end_time: nil, in_progress: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all clockins", %{conn: conn} do
      conn = get(conn, ~p"/api/clockins")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create clockin" do
    test "renders clockin when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/clockins", clockin: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/clockins/#{id}")

      assert %{
               "id" => ^id,
               "end_time" => "2025-09-23T13:07:00Z",
               "in_progress" => true,
               "start_time" => "2025-09-23T13:07:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/clockins", clockin: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update clockin" do
    setup [:create_clockin]

    test "renders clockin when data is valid", %{conn: conn, clockin: %Clockin{id: id} = clockin} do
      conn = put(conn, ~p"/api/clockins/#{clockin}", clockin: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/clockins/#{id}")

      assert %{
               "id" => ^id,
               "end_time" => "2025-09-24T13:07:00Z",
               "in_progress" => false,
               "start_time" => "2025-09-24T13:07:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, clockin: clockin} do
      conn = put(conn, ~p"/api/clockins/#{clockin}", clockin: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete clockin" do
    setup [:create_clockin]

    test "deletes chosen clockin", %{conn: conn, clockin: clockin} do
      conn = delete(conn, ~p"/api/clockins/#{clockin}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/clockins/#{clockin}")
      end
    end
  end

  defp create_clockin(_) do
    clockin = clockin_fixture()

    %{clockin: clockin}
  end
end
