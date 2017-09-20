defmodule KraalWeb.MarkdownHelpers do
  use Phoenix.HTML

  def markdown(text) do
    post = Earmark.as_html!(text)
    raw(post)
  end
end
