defmodule Kraal.Web.Handler do
  require Logger
  alias Phoenix.Controller
  alias Kraal.Web.Router.Helpers

  def unauthenticated(conn, %{reason: reason}) do
    case reason do
      {:error, :no_session} ->
        conn
        |> Controller.put_flash(:error, "You have to authenticate.")
        |> Controller.redirect(
          to: Helpers.session_path(conn, :new,
          [redirect_after: conn.request_path])
          )
      {:error, error_reason} ->
        Logger.error "Reason #{error_reason} needs to be implemented"
        conn
        |> Controller.put_flash(:error, "You have to authenticate.")
        |> Controller.redirect.redirect(
          to: Helpers.session_path(conn, :new,
          [redirect_after: conn.request_path])
          )
    end
  end

end
