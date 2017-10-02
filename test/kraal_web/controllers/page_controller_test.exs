defmodule KraalWeb.PageControllerTest do
  use KraalWeb.ConnCase

  import Kraal.Factory

  test "GET /", %{conn: conn} do
    posts = insert_list(5, :post)
    conn = get conn, "/"
    Enum.each(posts, fn(post) ->
      assert html_response(conn, 200) =~ post.title
    end)
  end
end
