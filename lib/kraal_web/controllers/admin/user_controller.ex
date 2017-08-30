defmodule KraalWeb.Admin.UserController do
  use KraalWeb, :controller

  alias Kraal.Coherence.Schemas
  alias Kraal.Coherence.User

  def index(conn, _params) do
    users = Kraal.Coherence.Schemas.list_user()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Schemas.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Schemas.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: admin_user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Schemas.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Schemas.get_user!(id)
    changeset = Schemas.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Schemas.get_user!(id)

    case Schemas.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: admin_user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Schemas.get_user!(id)
    {:ok, _user} = Admin.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: admin_user_path(conn, :index))
  end
end