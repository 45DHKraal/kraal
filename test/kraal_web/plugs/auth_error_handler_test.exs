defmodule KraalWeb.Plugs.AuthErrorHandlerTest do
  use KraalWeb.ConnCase

  alias KraalWeb.Plugs.AuthErrorHandler

  describe("#auth_error") do
    test "redirect to login page for auth error", %{conn: conn} do
      conn = AuthErrorHandler.auth_error(conn, {:unauthorized, nil}, nil)
      assert redirected_to(conn) == session_path(conn, :new)
    end
  end
end
