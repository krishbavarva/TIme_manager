defmodule GothamScheduler.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GothamScheduler.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        firstname: "some firstname",
        lastname: "some lastname",
        password: "some password",
        username: "some username"
      })
      |> GothamScheduler.Accounts.create_user()

    user
  end
end
