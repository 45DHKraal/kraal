defmodule KraalWeb.Plugs.RoleCheckerTest do
  use KraalWeb.ConnCase

  alias KraalWeb.Plugs.RoleChecker

  describe("Role checker: admin user") do
    @moduletag user: :admin

    test "always pass admin user", %{conn: conn} do
      assert %Plug.Conn{:halted => false} = RoleChecker.call(conn)
      assert %Plug.Conn{:halted => false} = RoleChecker.call(conn, [only: [:admin]])
      assert %Plug.Conn{:halted => false} = RoleChecker.call(conn, [only: [:active_scout]])
      assert %Plug.Conn{:halted => false} = RoleChecker.call(conn, [only: [:cms_admin]])
      assert %Plug.Conn{:halted => false} = RoleChecker.call(conn, [only: [:admin, :active_scout, :cms_admin]])
    end

  end

  describe("Role checker: active scout") do
    @moduletag user: :active_scout

    test "halt for restricted", %{conn: conn} do
      assert %Plug.Conn{:halted => true} = RoleChecker.call(conn, [only: [:admin]])
      assert %Plug.Conn{:halted => true} = RoleChecker.call(conn, [only: [:cms_admin]])
      assert %Plug.Conn{:halted => true} = RoleChecker.call(conn, [only: [:cms_admin, :admin]])
    end

    test "pass for allowed", %{conn: conn} do
      assert %Plug.Conn{:halted => false} = RoleChecker.call(conn, [only: [:cms_admin, :admin, :active_scout]])
      assert %Plug.Conn{:halted => false} = RoleChecker.call(conn, [only: [:active_scout]])
      assert %Plug.Conn{:halted => false} = RoleChecker.call(conn)
    end

  end

  describe("Role checker: cms admin") do
    @moduletag user: :cms_admin

    test "halt for restricted", %{conn: conn} do
      assert %Plug.Conn{:halted => true} = RoleChecker.call(conn, [only: [:admin]])
    end

    test "pass for allowed", %{conn: conn} do
      assert %Plug.Conn{:halted => false} = RoleChecker.call(conn)
      assert %Plug.Conn{:halted => false} = RoleChecker.call(conn, [only: [:active_scout]])
      assert %Plug.Conn{:halted => false} = RoleChecker.call(conn, [only: [:cms_admin]])
      assert %Plug.Conn{:halted => false} = RoleChecker.call(conn, [only: [:cms_admin, :admin, :active_scout]])
    end
  end

  describe("Role checker: no role") do
    @moduletag :user

    test "halt for restricted", %{conn: conn} do
      assert %Plug.Conn{:halted => true} = RoleChecker.call(conn)
      assert %Plug.Conn{:halted => true} = RoleChecker.call(conn, [only: [:admin]])
      assert %Plug.Conn{:halted => true} = RoleChecker.call(conn, [only: [:active_scout]])
      assert %Plug.Conn{:halted => true} = RoleChecker.call(conn, [only: [:cms_admin]])
      assert %Plug.Conn{:halted => true} = RoleChecker.call(conn, [only: [:cms_admin, :admin, :active_scout]])
    end
  end

end
