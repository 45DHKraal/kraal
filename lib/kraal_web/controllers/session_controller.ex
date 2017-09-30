defmodule KraalWeb.SessionController do
  use KraalWeb, :controller

  alias Kraal.Accounts
  alias Kraal.Accounts.User

  require IEx

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.login(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Session created successfully.")
        |> Kraal.Guardian.Plug.sign_in(user)
        |> redirect(to: page_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end


  def delete(conn, _params) do
    session = {}
    {:ok, _session} = Accounts.logout(session)

    conn
    |> put_flash(:info, "Session deleted successfully.")
    |> redirect(to: session_path(conn, :index))
  end
end
