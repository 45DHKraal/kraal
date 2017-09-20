defmodule Mix.Tasks.WpImport.Users do
  use Mix.Task

  import SweetXml
  import Mix.Ecto

  alias Kraal.Accounts.{User, Profile}

  @shortdoc "Import users from wordpress export file"
  @moduledoc "  This is where we would put any long form documentation or doctests.\n"

  def run(file) do
    ensure_started Kraal.Repo, []
    users =
      file
      |> Path.expand()
      |> File.read!()
      |> parse(namespace_conformant: true)
      |> xpath(~x(//channel/wp:author)l)
      |> Enum.map(fn user ->
          profile = %{
            first_name: xpath(user, ~x[//wp:author_first_name/text()]s),
            last_name: xpath(user, ~x[//wp:author_last_name/text()]s),
          }
                    password =
                      :crypto.strong_rand_bytes(16)
                      |> Base.encode64()
                      |> binary_part(0, 16)
                    email =
                      case user
                           |> xpath(~x[//wp:author_email/text()]) do
                        email when length(email) > 0 ->
                          to_string email

                        _ ->
                          "#{user
                            |> xpath(~x[//wp:author_login/text()]s)}@kraal.pl"
                      end
                    Mix.shell().info("Import user #{email}")
                    User.changeset(%User{},
                                   %{
                                     email: email,
                                     password: password,
                                     active: false,
                                   })
                    |> Kraal.Repo.insert!()
                    |> Ecto.build_assoc(:profile, profile)
                    |> Kraal.Repo.insert!()

                  end)
    Mix.shell().info "Imported #{length(users)} users"
  end
end
