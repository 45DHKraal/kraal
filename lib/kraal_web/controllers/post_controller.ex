defmodule KraalWeb.PostController do
  use KraalWeb, :controller

  alias Kraal.Cms

  def index(conn, %{"page" => page}) do
    page = Cms.get_posts_page(page)
    render(conn, "index.html", page: page)
  end

  def index(conn, _params) do
    page= Cms.get_posts_page
    render(conn, "index.html", page: page)
  end

  def show(conn, %{"slug" => slug}) do
    post = Cms.get_post_by_slug!(slug)
    render(conn, "show.html", post: post)
  end

end
