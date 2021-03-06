defmodule KraalWeb.Panel.PageControllerTest do
  use KraalWeb.ConnCase

  alias Kraal.Cms

  @moduletag user: :cms_admin
  @moduletag :skip

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:page) do
    {:ok, page} = Cms.create_page(@create_attrs)
    page
  end

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get conn, panel_page_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Posts"
    end
  end

  describe "new page" do
    test "renders form", %{conn: conn} do
      conn = get conn, panel_page_path(conn, :new)
      assert html_response(conn, 200) =~ "New Page"
    end
  end

  describe "create page" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, panel_page_path(conn, :create), page: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == panel_page_path(conn, :show, id)

      conn = get conn, panel_page_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Page"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, panel_page_path(conn, :create), page: @invalid_attrs
      assert html_response(conn, 200) =~ "New Page"
    end
  end

  describe "edit page" do
    setup [:create_page]

    test "renders form for editing chosen page", %{conn: conn, page: page} do
      conn = get conn, panel_page_path(conn, :edit, page)
      assert html_response(conn, 200) =~ "Edit Page"
    end
  end

  describe "update page" do
    setup [:create_page]

    test "redirects when data is valid", %{conn: conn, page: page} do
      conn = put conn, panel_page_path(conn, :update, page), page: @update_attrs
      assert redirected_to(conn) == panel_page_path(conn, :show, page)

      conn = get conn, panel_page_path(conn, :show, page)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, page: page} do
      conn = put conn, panel_page_path(conn, :update, page), page: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Page"
    end
  end

  describe "delete page" do
    setup [:create_page]

    test "deletes chosen page", %{conn: conn, page: page} do
      conn = delete conn, panel_page_path(conn, :delete, page)
      assert redirected_to(conn) == panel_page_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, panel_page_path(conn, :show, page)
      end
    end
  end

  defp create_page(_) do
    page = fixture(:page)
    {:ok, page: page}
  end
end
