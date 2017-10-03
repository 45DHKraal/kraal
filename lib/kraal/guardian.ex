defmodule Kraal.Guardian do
  use Guardian, otp_app: :kraal

  alias Kraal.Accounts
  alias Kraal.Accounts.User

  def subject_for_token(%User{} = user, _claims) do
    {:ok, "User:" <> to_string(user.id)}
  end

  def subject_for_token(_, _) do
    {:error, :unknown_resource}
  end

  def resource_from_claims(%{"sub" => "User:" <> uid_str}) do
    case Ecto.UUID.cast(uid_str) do
      {:ok, uid} ->
        {:ok, Accounts.get_user!(uid)}
      _ ->
        {:error, :invalid_id}
    end
    rescue
      Ecto.NoResultsError ->
        {:error, :no_result}
  end

  def resource_from_claims(_claims) do
    {:error, :invalid_claims}
  end

end
