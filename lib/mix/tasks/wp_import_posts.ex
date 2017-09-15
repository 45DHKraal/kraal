defmodule Mix.Tasks.WpImport.Posts do
  use Mix.Task

  import SweetXml
  import Mix.Ecto

  alias Kraal.Accounts.User
  alias Kraal.Cms.Post

  @shortdoc "Import users from wordpress export file"
  @moduledoc "  This is where we would put any long form documentation or doctests.\n"

  def run(file) do
    ensure_started Kraal.Repo, []
    data =
      file
      |> Path.expand()
      |> File.read!()
      |> parse(namespace_conformant: true)
    with posts <- map_post_and_group_by_authors(data),
         authors <- map_authors(data) do
           Enum.each(authors, fn author ->
             Enum.each(posts[author.login], fn post ->
                               Ecto.build_assoc(author.profile, :posts,
                                                %{ title: post.title,
                                                   content: post.content,
                                                   slug: post.slug,
                                                   published_at: post.publication_date,
                                                   author_id: author.profile.id,
                                                   status:  String.to_atom(post.status)
                                                   })
                               |> Kraal.Repo.insert!()
                             end)

           end)
    end
    Mix.shell().info "Imported posts"
  end


  defp map_authors(data) do
    data
    |> xpath(~x(//channel/wp:author)l)
    |> Enum.map(fn user ->
                  email = get_author_email(user)
                  %{
                    login: xpath(user, ~x[//wp:author_login/text()]s),
                    profile: Kraal.Repo.get_by!(User, email: email),
                  }
                end)
  end


  defp map_post_and_group_by_authors(data) do
    data
    |> xpath(~x(//channel/item[wp:post_type='post'])l)
    |> Enum.map(fn post ->
                  publication_date =
                    post
                    |> xpath(~x[//wp:post_date/text()]s)
                    |> NaiveDateTime.from_iso8601!()
                  slug = xpath(post, ~x[//wp:post_name/text()]s)
                  %{title: xpath(post, ~x[//title/text()]s),
                    publication_date: publication_date,
                     content: xpath(post, ~x[//content:encoded/text()]s),
                     author: xpath(post, ~x[//dc:creator/text()]s),
                     slug: slug,
                     status: xpath(post, ~x[//wp:status/text()]s),
                     url: "/#{publication_date.year}/#{publication_date.month}/#{slug}"}
                end)
    |> Enum.group_by(&Map.get(&1, :author))
  end


  defp get_author_email(user) do
    case user
         |> xpath(~x[//wp:author_email/text()]) do
      email when length(email) > 0 -> to_string email
      _ ->
        "#{xpath(user, ~x[//wp:author_login/text()]s)}@kraal.pl"
    end
  end
end
