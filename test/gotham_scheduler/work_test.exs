defmodule GothamScheduler.WorkTest do
  use GothamScheduler.DataCase

  alias GothamScheduler.Work

  describe "working_times" do
    alias GothamScheduler.Work.WorkingTime

    import GothamScheduler.WorkFixtures

    @invalid_attrs %{start_time: nil, end_time: nil}

    test "list_working_times/0 returns all working_times" do
      working_time = working_time_fixture()
      assert Work.list_working_times() == [working_time]
    end

    test "get_working_time!/1 returns the working_time with given id" do
      working_time = working_time_fixture()
      assert Work.get_working_time!(working_time.id) == working_time
    end

    test "create_working_time/1 with valid data creates a working_time" do
      valid_attrs = %{start_time: ~U[2025-09-23 13:05:00Z], end_time: ~U[2025-09-23 13:05:00Z]}

      assert {:ok, %WorkingTime{} = working_time} = Work.create_working_time(valid_attrs)
      assert working_time.start_time == ~U[2025-09-23 13:05:00Z]
      assert working_time.end_time == ~U[2025-09-23 13:05:00Z]
    end

    test "create_working_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Work.create_working_time(@invalid_attrs)
    end

    test "update_working_time/2 with valid data updates the working_time" do
      working_time = working_time_fixture()
      update_attrs = %{start_time: ~U[2025-09-24 13:05:00Z], end_time: ~U[2025-09-24 13:05:00Z]}

      assert {:ok, %WorkingTime{} = working_time} = Work.update_working_time(working_time, update_attrs)
      assert working_time.start_time == ~U[2025-09-24 13:05:00Z]
      assert working_time.end_time == ~U[2025-09-24 13:05:00Z]
    end

    test "update_working_time/2 with invalid data returns error changeset" do
      working_time = working_time_fixture()
      assert {:error, %Ecto.Changeset{}} = Work.update_working_time(working_time, @invalid_attrs)
      assert working_time == Work.get_working_time!(working_time.id)
    end

    test "delete_working_time/1 deletes the working_time" do
      working_time = working_time_fixture()
      assert {:ok, %WorkingTime{}} = Work.delete_working_time(working_time)
      assert_raise Ecto.NoResultsError, fn -> Work.get_working_time!(working_time.id) end
    end

    test "change_working_time/1 returns a working_time changeset" do
      working_time = working_time_fixture()
      assert %Ecto.Changeset{} = Work.change_working_time(working_time)
    end
  end

  describe "clockins" do
    alias GothamScheduler.Work.Clockin

    import GothamScheduler.WorkFixtures

    @invalid_attrs %{start_time: nil, end_time: nil, in_progress: nil}

    test "list_clockins/0 returns all clockins" do
      clockin = clockin_fixture()
      assert Work.list_clockins() == [clockin]
    end

    test "get_clockin!/1 returns the clockin with given id" do
      clockin = clockin_fixture()
      assert Work.get_clockin!(clockin.id) == clockin
    end

    test "create_clockin/1 with valid data creates a clockin" do
      valid_attrs = %{start_time: ~U[2025-09-23 13:07:00Z], end_time: ~U[2025-09-23 13:07:00Z], in_progress: true}

      assert {:ok, %Clockin{} = clockin} = Work.create_clockin(valid_attrs)
      assert clockin.start_time == ~U[2025-09-23 13:07:00Z]
      assert clockin.end_time == ~U[2025-09-23 13:07:00Z]
      assert clockin.in_progress == true
    end

    test "create_clockin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Work.create_clockin(@invalid_attrs)
    end

    test "update_clockin/2 with valid data updates the clockin" do
      clockin = clockin_fixture()
      update_attrs = %{start_time: ~U[2025-09-24 13:07:00Z], end_time: ~U[2025-09-24 13:07:00Z], in_progress: false}

      assert {:ok, %Clockin{} = clockin} = Work.update_clockin(clockin, update_attrs)
      assert clockin.start_time == ~U[2025-09-24 13:07:00Z]
      assert clockin.end_time == ~U[2025-09-24 13:07:00Z]
      assert clockin.in_progress == false
    end

    test "update_clockin/2 with invalid data returns error changeset" do
      clockin = clockin_fixture()
      assert {:error, %Ecto.Changeset{}} = Work.update_clockin(clockin, @invalid_attrs)
      assert clockin == Work.get_clockin!(clockin.id)
    end

    test "delete_clockin/1 deletes the clockin" do
      clockin = clockin_fixture()
      assert {:ok, %Clockin{}} = Work.delete_clockin(clockin)
      assert_raise Ecto.NoResultsError, fn -> Work.get_clockin!(clockin.id) end
    end

    test "change_clockin/1 returns a clockin changeset" do
      clockin = clockin_fixture()
      assert %Ecto.Changeset{} = Work.change_clockin(clockin)
    end
  end
end
