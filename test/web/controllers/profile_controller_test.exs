defmodule Kraal.Web.ProfileControllerTest do
  use Kraal.Web.ConnCase

  alias Kraal.Accounts

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:profile) do
    {:ok, profile} = Accounts.create_profile(@create_attrs)
    profile
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, profile_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Profiles"
  end

  test "renders form for new profiles", %{conn: conn} do
    conn = get conn, profile_path(conn, :new)
    assert html_response(conn, 200) =~ "New Profile"
  end

  test "creates profile and redirects to show when data is valid", %{conn: conn} do
    conn = post conn, profile_path(conn, :create), profile: @create_attrs

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == profile_path(conn, :show, id)

    conn = get conn, profile_path(conn, :show, id)
    assert html_response(conn, 200) =~ "Show Profile"
  end

  test "does not create profile and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, profile_path(conn, :create), profile: @invalid_attrs
    assert html_response(conn, 200) =~ "New Profile"
  end

  test "renders form for editing chosen profile", %{conn: conn} do
    profile = fixture(:profile)
    conn = get conn, profile_path(conn, :edit, profile)
    assert html_response(conn, 200) =~ "Edit Profile"
  end

  test "updates chosen profile and redirects when data is valid", %{conn: conn} do
    profile = fixture(:profile)
    conn = put conn, profile_path(conn, :update, profile), profile: @update_attrs
    assert redirected_to(conn) == profile_path(conn, :show, profile)

    conn = get conn, profile_path(conn, :show, profile)
    assert html_response(conn, 200)
  end

  test "does not update chosen profile and renders errors when data is invalid", %{conn: conn} do
    profile = fixture(:profile)
    conn = put conn, profile_path(conn, :update, profile), profile: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Profile"
  end

  test "deletes chosen profile", %{conn: conn} do
    profile = fixture(:profile)
    conn = delete conn, profile_path(conn, :delete, profile)
    assert redirected_to(conn) == profile_path(conn, :index)
    assert_error_sent 404, fn ->
      get conn, profile_path(conn, :show, profile)
    end
  end
end
