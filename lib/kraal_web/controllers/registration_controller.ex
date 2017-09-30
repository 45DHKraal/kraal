defmodule KraalWeb.RegistrationController do
  use KraalWeb, :controller

  alias Kraal.Accounts
  alias Kraal.Accounts.User

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"registration" => registration_params}) do
    case Accounts.register_user(registration_params) do
      {:ok, registration} ->
        conn
        |> put_flash(:info, "Registration created successfully.")
        |> redirect(to: page_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end


end
