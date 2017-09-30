defmodule KraalWeb.Plugs.RoleCheckerTest do
  use KraalWeb.ConnCase

  import Kraal.Factory

  alias KraalWeb.Plugs.RoleChecker

  describe("Role checker: admin user") do
    setup :create_admin

    test "always pass admin user", %{conn: conn} do
      assert %Plug.Conn{:halted => false} = RoleChecker.call(conn)
      assert %Plug.Conn{:halted => false} = RoleChecker.call(conn, [only: [:admin]])
      assert %Plug.Conn{:halted => false} = RoleChecker.call(conn, [only: [:active_scout]])
      assert %Plug.Conn{:halted => false} = RoleChecker.call(conn, [only: [:cms_admin]])
      assert %Plug.Conn{:halted => false} = RoleChecker.call(conn, [only: [:admin, :active_scout, :cms_admin]])
    end

  end

  describe("Role checker: active scout") do
    setup :create_active_scout

    test "halt for restricted", %{conn: conn} do
      assert %Plug.Conn{:halted => true} = RoleChecker.call(conn, [only: [:admin]])
      assert %Plug.Conn{:halted => true} = RoleChecker.call(conn, [only: [:cms_admin]])
      assert %Plug.Conn{:halted => true} = RoleChecker.call(conn, [only: [:cms_admin, :admin]])
    end

    test "pass for allowed", %{conn: conn} do
      assert %Plug.Conn{:halted => false} = RoleChecker.call(conn, [only: [:cms_admin, :admin, :active_scout]])
      assert %Plug.Conn{:halted => false} = RoleChecker.call(conn, [only: [:active_scout]])
    end

  end

  describe("Role checker: cms admin") do
    setup :create_cms_admin

    test "halt for restricted", %{conn: conn} do
      assert %Plug.Conn{:halted => true} = RoleChecker.call(conn, [only: [:admin]])
    end

    test "pass for allowed", %{conn: conn} do
      assert %Plug.Conn{:halted => false} = RoleChecker.call(conn, [only: [:active_scout]])
      assert %Plug.Conn{:halted => false} = RoleChecker.call(conn, [only: [:cms_admin]])
      assert %Plug.Conn{:halted => false} = RoleChecker.call(conn, [only: [:cms_admin, :admin, :active_scout]])
    end

  end

  defp create_admin(params) do
    build(:user)
    |> user_admin
    |> insert
    |> assign_user_to_params(params)
  end

  defp create_active_scout(params) do
    build(:user)
    |> user_active_scout
    |> insert
    |> assign_user_to_params(params)
  end

  defp create_cms_admin(params) do
    build(:user)
    |> user_cms_admin
    |> insert
    |> assign_user_to_params(params)
  end

  defp assign_user_to_params(user, params) do
    conn = params.conn
    |> Kraal.Guardian.Plug.sign_in(user)
    %{params | conn: conn}
  end


end
