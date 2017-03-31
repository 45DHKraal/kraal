defmodule Kraal.Web.Admin.UserController do
  use Kraal.Web, :controller
  require Logger

  alias Kraal.Accounts

  def index(conn, _param) do
    users = Accounts.list_users
    render conn, "index.html", users: users
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%Accounts.User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "<%= schema.human_singular %> created successfully.")
        |> redirect(to: admin_user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        Logger.info fn -> {
          "Admin changes to user: #{user.id}",
          [changes: user.changes]
        } end
        conn
        |> put_flash(:info, "<%= schema.human_singular %> updated successfully.")
        |> redirect(to: admin_user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)
    Logger.warn("User #{id} removed.")
    conn
    |> put_flash(:info, "<%= schema.human_singular %> deleted successfully.")
    |> redirect(to: admin_user_path(conn, :index))
  end

end
