defmodule Kraal.Accounts.ProfileFactory do
  defmacro __using__(_opts) do
    quote do
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
  end
end
