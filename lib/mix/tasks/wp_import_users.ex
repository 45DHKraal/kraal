defmodule Mix.Tasks.WpImport.Users do
  use Mix.Task
  import SweetXml

  @shortdoc "Import users from wordpress export file"

  @moduledoc """
    This is where we would put any long form documentation or doctests.
  """

  def run(file) do
    users = file
    |> Path.expand
    |> File.read!
    |> parse(namespace_conformant: true)
    |> xpath(~x"//channel/wp:author"l)
    |> Enum.map( fn(user) ->
      %{
        login: user |> xpath( ~x"//wp:author_email/text()"),
        nick: user |> xpath( ~x"//wp:author_login/text()")
        } end)

IO.inspect(users)
    Mix.shell.info "Greetings from the Hello Phoenix Application!"
  end

end
