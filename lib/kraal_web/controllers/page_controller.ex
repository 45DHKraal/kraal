defmodule KraalWeb.PageController do
  use KraalWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
