defmodule KraalWeb.Admin.LayoutView do
  use KraalWeb, :view
  require IEx

  @routes [
    {gettext("Dashboard"), {:admin_dashboard_path, :index}, "home"},
    {gettext("User"), {:admin_user_path, :index}, "user"},
    {gettext("Invitations"), {:admin_invitation_path, :index}, "envelope"}
  ]

  def get_admin_link(conn) do
    Enum.map(@routes, fn({name, {helper, action}, icon})->
      path = get_link(conn, helper, action)
      %{name: name, icon: icon, path: path, active: path == conn.request_path}
    end)
  end

  defp get_link(conn, helper, action) do
    apply(KraalWeb.Router.Helpers, helper, [conn, action])
  end

  defp render_menu_link(link_text, link_to, icon, active \\ false ) do
    class = case active do
      true -> "item active"
      _ -> "item"
    end

    link to: link_to, class: class do
      [content_tag(:span, class: "icon" ) do
        content_tag(:i, "", class: "fa fa-#{icon}")
      end,
      content_tag(:span, link_text, class: "name")]
    end
  end
end
