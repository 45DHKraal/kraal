defmodule Kraal.Web.LayoutView do
  use Kraal.Web, :view
  require IEx

  @routes [%{text: gettext("Homepage"), helper: :page_path, action: :index}]

  def render_nav(conn) do
    content_tag(:nav, role: "navigation") do
      content_tag(:ul) do

        for route <- @routes do
          route_link = get_link(conn, route.helper, route.action)
          case conn.request_path do
            ^route_link when route_link != "/" ->
               render_nav_link(conn, route.text, route_link, true)
            link ->
              render_nav_link(conn, route.text, route_link)
          end
        end

      end
    end
  end

  defp render_nav_link(conn, link_text, link_to, active \\ false ) do
    content_tag(:li, link(link_text, to: link_to))
  end

  defp get_link(conn, helper, action) do
     apply(Kraal.Web.Router.Helpers, helper, [conn, action])
   end

end
