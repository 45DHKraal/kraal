defmodule Mix.Tasks.WpImport.Posts do
  use Mix.Task
  import SweetXml

  @shortdoc "Import users from wordpress export file"

  @moduledoc """
    This is where we would put any long form documentation or doctests.
  """

  def run(file) do
    posts = file
    |> Path.expand
    |> File.read!
    |> parse(namespace_conformant: true)
    |> xpath(~x"//channel/item[wp:post_type='post']"l)
    |> Enum.map( fn(post) ->
      publication_date = post |> xpath(~x"//wp:post_date/text()") |> to_string |> NaiveDateTime.from_iso8601!
      slug = post |> xpath(~x"//wp:post_name/text()")
       %{
      title: post |> xpath(~x"//title/text()") |> to_string(),
      publication_date: publication_date,
      content: post |> xpath(~x"//content:encoded/text()") |> to_string,
      author: post |> xpath(~x"//dc:creator/text()") |> to_string(),
      disqus_thread: post |> xpath(~x"//wp:postmeta[wp:meta_key='dsq_thread_id']/wp:meta_value/text()"),
      slug: slug,
      status: post |> xpath(~x"//wp:status/text()"),
      url: "/#{publication_date.year}/#{publication_date.month}/#{slug}"
      } end)
    |> Enum.group_by(&(Map.get(&1, :author)))
IO.inspect(posts)
    Mix.shell.info "Greetings from the Hello Phoenix Application!"
  end

end
