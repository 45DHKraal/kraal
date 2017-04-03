defmodule Kraal.Emails do
  use Bamboo.Phoenix, view: Kraal.Web.EmailView

  def activation_email(activation_token, user) do
    base_email
    |> to(user.email)
    |> subject("Aktywacja konta")
    |> assign(:activation_token, activation_token)
    |> assign(:user, user)
    |> render(:activation)
  end

  defp base_email do
    new_email
    |> from("45 Drużyna Harcerzy Kraal <kontakt@kraal.pl>")
    |> put_html_layout({Kraal.Web.LayoutView, "email.html"})
  end

end
