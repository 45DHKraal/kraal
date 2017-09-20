defmodule KraalWeb.PageController do
  use KraalWeb, :controller

  alias Kraal.Cms

  def index(conn, _params) do
    posts = Cms.get_posts_page
    render conn, "index.html", posts: posts.entries
  end
end
