defmodule KraalWeb.PostControllerTest do
  use KraalWeb.ConnCase

  alias Kraal.Cms

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:post) do
    {:ok, post} = Cms.create_post(@create_attrs)
    post
  end

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get conn, post_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Posts"
    end
  end

end
