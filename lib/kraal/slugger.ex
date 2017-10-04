defimpl Slugify, for: Kraal.Cms.Post do
  def slugify(%Kraal.Cms.Post{title: title, published_at: %DateTime{:year=> year, :month=> month}} = post) do
     "/#{year}/#{month}/#{Slugger.slugify_downcase(title)}"
   end
end

defimpl Slugify, for: Ecto.Changeset do
  def slugify(%Ecto.Changeset{data: %Kraal.Cms.Post{}} = changeset) do
    if changeset.valid? do
      %DateTime{:year=> year, :month=> month} = Ecto.Changeset.get_change(changeset, :published_at, DateTime.utc_now())
      title = Ecto.Changeset.get_change(changeset, :title, "")

      Ecto.Changeset.put_change(changeset, :slug, "/#{year}/#{month}/#{Slugger.slugify_downcase(title)}")
    else
      changeset
    end
   end
end
