defmodule Kraal.Cms.PostFactory do
  defmacro __using__(_opts) do
    quote do
      def post_factory do
           %Kraal.Cms.Post{
             title: FakerElixir.Lorem.words(2..4),
             content: FakerElixir.Lorem.sentences(3..5),
             status: :publish,
             published_at: DateTime.utc_now(),
             author: build(:profile)
           }
           |> create_slug()
      end

      def create_slug(post) do
        %{post | slug: Slugify.slugify(post)}
      end
    end
  end
end
