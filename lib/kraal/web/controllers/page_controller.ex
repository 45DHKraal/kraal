defmodule Kraal.Web.PageController do
  use Kraal.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
