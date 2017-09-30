defmodule KraalWeb.Plugs.AuthErrorHandler do
  import Plug.Conn

  def auth_error(conn, {type, reason}, _opts) do
    path = KraalWeb.Router.Helpers.session_path(conn, :new)
    conn
    |> Phoenix.Controller.redirect(to: path)
    |> halt
  end
end
