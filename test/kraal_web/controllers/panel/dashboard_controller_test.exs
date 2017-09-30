defmodule KraalWeb.Panel.DashboardControllerTest do
  use KraalWeb.ConnCase

  alias Kraal.Panel

  describe "index" do
    test "lists all dashboard", %{conn: conn} do
      conn = get conn, panel_dashboard_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Dashboard"
    end
  end

end
