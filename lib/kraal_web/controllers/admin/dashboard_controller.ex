defmodule KraalWeb.Admin.DashboardController do
  use KraalWeb, :controller

  def index(conn, _params) do
    conn
    |> assign(:header_data, get_header_data())
    |> assign(:notifications, get_admin_notifications())
    |> render "dashboard.html"
  end

  defp get_header_data do
    [{"User", Kraal.Repo.aggregate(Kraal.Coherence.User, :count, :id)}]
  end

  defp get_admin_notifications do
    [{1, false, "testtest"},
    {2, true, "testtest"}]
  end

end
