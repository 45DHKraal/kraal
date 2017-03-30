defmodule Kraal.Emails do
  import Bamboo.Email
  import Bamboo.Phoenix

  def activation_email(activation_token, user) do
    Bamboo.Email.new_email
    |> to(user.email)
    |> from("test@kraal.pl")
    |> subject("Aktywacja konta")
    |> text_body("test")
  end

end
