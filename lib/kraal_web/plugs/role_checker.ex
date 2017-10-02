defmodule KraalWeb.Plugs.RoleChecker do
  import Plug.Conn

  alias Kraal.Accounts.User

  def init(opts), do: opts

  def call(conn, opts \\ [only: [:active_scout]]) do
    %Kraal.Accounts.User{:roles => roles} = Guardian.Plug.current_resource(conn)
     if verify_user_roles(roles, opts) do
       conn
     else
       halt(conn)
     end
  end

  defp verify_user_roles(%User.Roles{admin: true}, _) do
    true
  end

  defp verify_user_roles(%User.Roles{cms_admin: true}, [only: [:active_scout]]) do
    true
  end

  defp verify_user_roles(roles, opts) do
    allowed = Keyword.get(opts, :only)
    Map.take(roles, allowed)
    |> Map.values
    |> Enum.any?(&(&1))
  end

end
