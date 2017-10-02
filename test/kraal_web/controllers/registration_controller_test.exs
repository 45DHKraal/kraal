defmodule KraalWeb.RegistrationControllerTest do
  use KraalWeb.ConnCase

  alias Kraal.Accounts

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}


  describe "new registration" do
    test "renders form", %{conn: conn} do
      conn = get conn, registration_path(conn, :new)
      assert html_response(conn, 200) =~ "New Registration"
    end
  end

  describe "create registration" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, registration_path(conn, :create), registration: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == registration_path(conn, :show, id)

      conn = get conn, registration_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Registration"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, registration_path(conn, :create), registration: @invalid_attrs
      assert html_response(conn, 200) =~ "New Registration"
    end
  end


end
