defmodule Kraal.Web.SessionController do
  use Kraal.Web, :controller

  alias Kraal.Accounts


  def new(conn, _params) do
    changeset = Accounts.change_user(%Kraal.Accounts.User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email"=> email, "password"=>password} = user_params
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Session created successfully.")
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: profile_path(conn, :show))
      {:error, :not_activated} ->
          conn
          |> put_flash(:error, "User not activated. Please check email.")   
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    # session = Accounts.get_session!(id)
    # {:ok, _session} = Accounts.delete_session(session)
    #
    # conn
    # |> put_flash(:info, "Session deleted successfully.")
    # |> redirect(to: session_path(conn, :index))
  end
end
