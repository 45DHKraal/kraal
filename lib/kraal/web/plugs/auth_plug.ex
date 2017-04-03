defmodule Kraal.Web.Plugs.Auth do
  import Plug.Conn
  alias Kraal.Accounts

  def init(opts), do: opts

  def call(conn, _) do
    try do
      user_id = get_session(conn, :user_id)
      user = Accounts.get_user!(user_id)
      assign(conn, :current_user, user)
    rescue
      _ -> conn
    end
  end
end
