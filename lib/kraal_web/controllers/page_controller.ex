defmodule KraalWeb.PageController do
  use KraalWeb, :controller

  def index(conn, _params) do
    posts = Kraal.Cms.get_posts
    render conn, "index.html", posts: posts
  end
end
