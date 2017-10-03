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
    |> where([u], is_nil(u.deleted_at))
    |> preload(:profile)
    |> Repo.one!
  end

  def login(%{"email"=> email, "password"=>password} \\ %{}) do
    changeset = change_user(%User{password: password, email: email})
    case login(email, password) do
      {:ok, user} -> {:ok, user}
      {_, error} ->
        {:error, Ecto.Changeset.add_error(changeset, :user, error)}
    end
  end

  defp login(email, password) do
    with user <- get_user_by_email(email),
      {:ok, _} <- User.is_confirmed(user),
      {:ok, _} <- User.check_password(user, password)
    do
      {:ok, user}
    else
      {:error, error} -> {:error, error}
    end
    rescue
      error ->
        Comeonin.Argon2.dummy_checkpw()
        {:error, "not exist"}
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
  Returns an `%Ecto.Changeset{}` for tracking profile changes.

  ## Examples

      iex> change_profile(profile)
      %Ecto.Changeset{source: %Profile{}}

  """
  def change_profile(%Profile{} = profile) do
    Profile.changeset(profile, %{})
  end
end
