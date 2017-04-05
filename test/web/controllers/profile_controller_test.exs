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

end
