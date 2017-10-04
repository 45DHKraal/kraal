defmodule KraalWeb.Admin.UserControllerTest do
  use KraalWeb.ConnCase, user: :admin

  alias Kraal.Accounts

  import Kraal.Factory

  @moduletag user: :admin
  @moduletag :skip

  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all users", %{conn: conn} do
      insert_list(10, :user)
      conn = get conn, admin_user_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get conn, admin_user_path(conn, :new)
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn} do

      conn = post conn, admin_user_path(conn, :create), user: string_params_for(:user_register)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == admin_user_path(conn, :show, id)

      conn = get conn, admin_user_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show User"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, admin_user_path(conn, :create), user: @invalid_attrs
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "edit user" do

    test "renders form for editing chosen user", %{conn: conn} do
      user = insert(:user)
      conn = get conn, admin_user_path(conn, :edit, user)
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update user" do

    test "redirects when data is valid", %{conn: conn} do
      user = insert(:user)
      conn = put conn, admin_user_path(conn, :update, user), user: @update_attrs
      assert redirected_to(conn) == admin_user_path(conn, :show, user)

      conn = get conn, admin_user_path(conn, :show, user)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = insert(:user)
      conn = put conn, admin_user_path(conn, :update, user), user: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "delete user" do

    test "deletes chosen user", %{conn: conn} do
      user = insert(:user)
      conn = delete conn, admin_user_path(conn, :delete, user)
      assert redirected_to(conn) == admin_user_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, admin_user_path(conn, :show, user)
      end
    end
  end
end
