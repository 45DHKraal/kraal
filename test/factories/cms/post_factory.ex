defmodule Kraal.Cms.PostFactory do
  defmacro __using__(_opts) do
    quote do
      def post_factory do
        title = FakerElixir.Lorem.words(2..4)
           %Kraal.Cms.Post{
             title: title,
             slug: Slugger.slugify_downcase(title),
             content: FakerElixir.Lorem.sentences(3..5),
             status: :publish,
             author: build(:profile)
           }
      end
    end
  end
end
