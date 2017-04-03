defmodule Kraal.Accounts do
  @moduledoc """
  The boundary for the Accounts system.
  """

  import Ecto.{Query, Changeset, Multi}, warn: false
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  alias Kraal.Repo
  alias Ecto.Multi
  require Logger

  alias Kraal.Accounts.User
  alias Kraal.Accounts.Roles

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    multi =
      Multi.new
      |> Multi.insert(:user, user_create_changeset(%User{}, attrs))
      |> Multi.run(:activation_token, fn %{user: user} ->
          create_activation_token(user)
        end)
    case Repo.transaction(multi) do
      {:ok, result} ->
        Logger.debug fn -> {
            "User with email #{result.user.email} created. Created activation token #{result.activation_token.id}",
            [user: result.user, activation_token: result.activation_token.id]
          } end
        Kraal.Emails.activation_email(result.activation_token, result.user)
        |> Kraal.Mailer.deliver_now
        {:ok, result.user}
      {:error, elem, changeset, %{}} ->
        Logger.error fn -> {
           "Problems during registration",
           [elem: elem, changeset: changeset]
          } end
        {:error, changeset}
    end
  end

  def activate_user(activation_token_id, user_id, user_data) do
    activation_token = get_activation_token!(activation_token_id)
    user = get_user!(user_id)
    |> user_activate_changeset(user_data)
    multi = Multi.new
    |> Multi.update(:user_update, user)
    |> Multi.delete(:delete_activation_token, activation_token)

    case Repo.transaction multi do
      {:ok, result} ->
        {:ok, result.user_update}
        {:error, elem, changeset, %{}} ->
          Logger.error fn -> {
             "Problems during activation",
             [elem: elem, changeset: changeset]
            } end
          {:error, changeset}
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> user_changeset(attrs)
    |> Repo.update()
  end


  def authenticate_user(email, password) do
    user = Repo.get_by(User, email: email)

    cond do
      nil == user ->
        dummy_checkpw
        {:error, change_user(%User{})}
      user.activated == false ->
          {:error, :user_not_activated}
      user && checkpw(password, user.password_hash) ->
        {:ok, user}
    end
  end
  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    user_changeset(user, %{})
  end

  defp user_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> cast_embed(:roles)
    |> validate_required([])
  end

  defp user_create_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email])
    |> put_embed(:roles, Roles.changeset(%Roles{}, attrs))
    |> validate_required([:email])
    |> unique_constraint(:email)
  end

  defp user_activate_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_confirmation(:password)
    |> put_change(:activated, true)
    |> put_pass_hash
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{ valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end

  alias Kraal.Accounts.ActivationToken

  @doc """
  Returns the list of activation_tokens.

  ## Examples

      iex> list_activation_tokens()
      [%ActivationToken{}, ...]

  """
  def list_activation_tokens do
    Repo.all(ActivationToken)
  end

  @doc """
  Gets a single activation_token.

  Raises `Ecto.NoResultsError` if the Activation token does not exist.

  ## Examples

      iex> get_activation_token!(123)
      %ActivationToken{}

      iex> get_activation_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_activation_token!(id), do: Repo.get!(ActivationToken, id)


  def validate_activation_token(activation_token_id, user_id) do
    try do
      case get_activation_token!(activation_token_id) do
        token = %ActivationToken{user_id: ^user_id} ->
          {:ok, token}
        nil ->
          {:error, :not_valid}
      end
    rescue
      _ -> {:error, :not_found}
    end
  end
  @doc """
  Creates a activation_token.

  ## Examples

      iex> create_activation_token(%{field: value})
      {:ok, %ActivationToken{}}

      iex> create_activation_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_activation_token(%Kraal.Accounts.User{} = user) do
    %ActivationToken{}
    |> activation_token_changeset(%{})
    |> put_assoc(:user, user)
    |> Repo.insert()
  end


  @doc """
  Deletes a ActivationToken.

  ## Examples

      iex> delete_activation_token(activation_token)
      {:ok, %ActivationToken{}}

      iex> delete_activation_token(activation_token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_activation_token(%ActivationToken{} = activation_token) do
    Repo.delete(activation_token)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking activation_token changes.

  ## Examples

      iex> change_activation_token(activation_token)
      %Ecto.Changeset{source: %ActivationToken{}}

  """
  def change_activation_token(%ActivationToken{} = activation_token) do
    activation_token_changeset(activation_token, %{})
  end

  defp activation_token_changeset(%ActivationToken{} = activation_token, attrs) do
    activation_token
    |> cast(attrs, [])
  end

end
