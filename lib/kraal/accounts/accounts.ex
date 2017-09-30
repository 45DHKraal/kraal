defmodule Kraal.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.Query, warn: false
  alias Kraal.Repo

  alias Kraal.Accounts.Profile
  alias Kraal.Accounts.User

  def list_user do
    Repo.all(User)
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.register_changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:profile, with: &Profile.changeset/2)
    |> Repo.insert
  end

  def get_user!(id) do
  User
  |> where(id: ^id)
  |> join(:left, [p], _ in assoc(p, :profile))
  |> preload([_, p], profile: p)
  |> Repo.one!
end

  def get_user_by_email(email) do
    User
    |> where(email: ^email)
    |> preload(:profile)
    |> Repo.one!
  end

  def login(%{"email"=> email, "password"=>password} \\ %{}) do
    changeset = change_user(%User{password: password, email: email})
    case login(email, password) do
      {:ok, user} -> {:ok, user}
      {_, error} ->
        {:error, changeset |> Ecto.Changeset.add_error(:user, get_login_error_message(error))}
        _ -> {:error, changeset |> Ecto.Changeset.add_error(:user, get_login_error_message())}
    end
  end

  defp login(email, password) do
    try do
      with user <- get_user_by_email(email),
        {:ok, _} <- User.is_confirmed(user),
        {:ok, _} <- User.is_active(user),
        {:ok, _} <- User.check_password(user, password)
      do
        {:ok, user}
      else
        {:error, error} -> {:error, error}
      end
    rescue
      error ->  Comeonin.Argon2.dummy_checkpw()
                {:error, error}
    end
  end

  defp get_login_error_message(error \\ nil) do
    case error do
      "invalid password" -> "invalid password"
      :not_active -> "not activated"
      :not_confirmed -> "not confirmed"
      _ -> "Login error"
    end
  end

  def logout(params) do

  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Returns the list of profile.

  ## Examples

      iex> list_profile()
      [%Profile{}, ...]

  """
  def list_profile do
    Repo.all(Profile)
  end

  @doc """
  Gets a single profile.

  Raises `Ecto.NoResultsError` if the Profile does not exist.

  ## Examples

      iex> get_profile!(123)
      %Profile{}

      iex> get_profile!(456)
      ** (Ecto.NoResultsError)

  """
  def get_profile!(id), do: Repo.get!(Profile, id)

  @doc """
  Creates a profile.

  ## Examples

      iex> create_profile(%{field: value})
      {:ok, %Profile{}}

      iex> create_profile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_profile(attrs \\ %{}) do
    %Profile{}
    |> Profile.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a profile.

  ## Examples

      iex> update_profile(profile, %{field: new_value})
      {:ok, %Profile{}}

      iex> update_profile(profile, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_profile(%Profile{} = profile, attrs) do
    profile
    |> Profile.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Profile.

  ## Examples

      iex> delete_profile(profile)
      {:ok, %Profile{}}

      iex> delete_profile(profile)
      {:error, %Ecto.Changeset{}}

  """
  def delete_profile(%Profile{} = profile) do
    Repo.delete(profile)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking profile changes.

  ## Examples

      iex> change_profile(profile)
      %Ecto.Changeset{source: %Profile{}}

  """
  def change_profile(%Profile{} = profile) do
    Profile.changeset(profile, %{})
  end
end
