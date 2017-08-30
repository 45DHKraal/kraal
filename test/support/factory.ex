defmodule Kraal.Factory do
  use ExMachina.Ecto, repo: Kraal.Repo

  def profile_factory do
    %Kraal.Accounts.Profile{
      first_name: FakerElixir.Name.first_name,
      last_name: FakerElixir.Name.last_name,
      birth_date: FakerElixir.Date.birthday |> Ecto.Date.cast!
    }
  end

  def profile_invalid_factory do
    build(:profile, %{first_name: "", last_name: "", birth_date: ""})
  end

end
