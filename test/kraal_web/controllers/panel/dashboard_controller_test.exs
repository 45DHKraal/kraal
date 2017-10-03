defmodule KraalWeb.Panel.DashboardControllerTest do
  use KraalWeb.ConnCase

  @moduletag user: :cms_admin

  describe "index" do
    test "lists all dashboard", %{conn: conn} do
      conn = get conn, panel_dashboard_path(conn, :index)
      assert html_response(conn, 200) =~ "Blog Panel 45 DH(y) Kraal"
      assert html_response(conn, 200) =~ "<h2>Summary</h2>"
    end
  end

end
