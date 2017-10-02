defmodule Kraal.Factory do
  use ExMachina.Ecto, repo: Kraal.Repo
  use Kraal.Accounts.UserFactory
  use Kraal.Accounts.ProfileFactory
  use Kraal.Cms.PostFactory

end
