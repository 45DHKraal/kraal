defmodule KraalWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  alias Kraal.Factory

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      import KraalWeb.Router.Helpers

      # The default endpoint for testing
      @endpoint KraalWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Kraal.Repo)
    conn = if tags[:user] do
      add_user(Phoenix.ConnTest.build_conn(), tags[:user])
    else
      Phoenix.ConnTest.build_conn()
    end

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Kraal.Repo, {:shared, self()})
    end
    {:ok, conn: conn}
  end

  def add_user(conn, true) do
    Kraal.Guardian.Plug.sign_in(conn, Kraal.Factory.build(:user))
  end

  def add_user(conn, type) do
    user = Kraal.Factory.build(:user)
    |> Kraal.Factory.user_add_role(type)
    Kraal.Guardian.Plug.sign_in(conn, user)
  end

end
