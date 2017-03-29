defmodule Kraal.Web.Admin.UserController do
  use Kraal.Web, :controller
  alias Kraal.User
  alias Kraal.Repo

  def index(conn, _param) do
    users = Repo.all(User)
    render conn, "index.html", users: users
  end

  def new(conn, _param) do
    changeset = User.create_changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user"=> user_params}) do
    changeset = User.create_changeset(%User{}, user_params)
    {:ok, user} = Repo.insert(changeset)

    conn
    |> put_flash(:info, "#{user.email} stworzony")
    |> redirect(to: admin_user_path(conn, :index))
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    render conn, "show.html", user: user
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    changeset =  User.changeset(user)
    render conn, "edit.html", user: user, changeset: changeset
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
    {:ok, user} ->
      conn
      |> put_flash(:info, "User updated successfully.")
      |> redirect(to: admin_user_path(conn, :show, user))
    {:error, changeset} ->
      render(conn, "edit.html", user: user, changeset: changeset)
  end
  end

end
