defmodule Kraal.Web.SessionControllerTest do
  use Kraal.Web.ConnCase

  alias Kraal.Accounts

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:session) do
    {:ok, session} = Accounts.create_session(@create_attrs)
    session
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, session_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Sessions"
  end

  test "renders form for new sessions", %{conn: conn} do
    conn = get conn, session_path(conn, :new)
    assert html_response(conn, 200) =~ "New Session"
  end

  test "creates session and redirects to show when data is valid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: @create_attrs

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == session_path(conn, :show, id)

    conn = get conn, session_path(conn, :show, id)
    assert html_response(conn, 200) =~ "Show Session"
  end

  test "does not create session and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: @invalid_attrs
    assert html_response(conn, 200) =~ "New Session"
  end

  test "renders form for editing chosen session", %{conn: conn} do
    session = fixture(:session)
    conn = get conn, session_path(conn, :edit, session)
    assert html_response(conn, 200) =~ "Edit Session"
  end

  test "updates chosen session and redirects when data is valid", %{conn: conn} do
    session = fixture(:session)
    conn = put conn, session_path(conn, :update, session), session: @update_attrs
    assert redirected_to(conn) == session_path(conn, :show, session)

    conn = get conn, session_path(conn, :show, session)
    assert html_response(conn, 200)
  end

  test "does not update chosen session and renders errors when data is invalid", %{conn: conn} do
    session = fixture(:session)
    conn = put conn, session_path(conn, :update, session), session: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Session"
  end

  test "deletes chosen session", %{conn: conn} do
    session = fixture(:session)
    conn = delete conn, session_path(conn, :delete, session)
    assert redirected_to(conn) == session_path(conn, :index)
    assert_error_sent 404, fn ->
      get conn, session_path(conn, :show, session)
    end
  end
end
