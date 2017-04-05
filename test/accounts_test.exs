defmodule Kraal.AccountsTest do
  use Kraal.DataCase

  alias Kraal.Accounts
  alias Kraal.Accounts.User

  @create_attrs %{email: "test@test.pl"}
  @created_attr %{activated: false}
  @activations_attrs %{password: "test", password_confirmation: "test"}
  @login_attrs %{email: "test@test.pl", password: "test"}
  # @update_attrs %{}
  @invalid_attrs %{}

  def fixture(type, attrs \\ @create_attrs) do
    {:ok, user, activation_token} = Accounts.create_user(attrs)
    case type do
      :user ->
        user
      :user_activated ->
        {:ok, user} = Accounts.activate_user(activation_token.id, user.id, @activations_attrs)
        user
      :user_with_activation_token ->
        {user, activation_token}
    end
  end

  test "create_user/1 with valid data creates a user" do
    assert {:ok, %User{} = user, _} = Accounts.create_user(@create_attrs)
    refute user.activated
  end

  test "create_user/1 with same email returns error changeset" do
    Accounts.create_user(@create_attrs)
    assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(@create_attrs)
    assert "has already been taken" in errors_on(changeset).email
  end

  test "create_user/1 without email returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
  end

  test "list_users/1 returns all users" do
    user = fixture(:user)
    assert Accounts.list_users() == [user]
  end

  test "get_user! returns the user with given id" do
    user = fixture(:user)
    assert Accounts.get_user!(user.id) == user
  end

  test "activate_user/3 with proper token returns activated user" do
    {user, activation_token} = fixture(:user_with_activation_token)
    {:ok, activated_user} = Accounts.activate_user(activation_token.id, user.id, @activations_attrs)
    assert activated_user.activated
    refute activated_user.password_hash == nil
  end

  test "activate_user/3 with not valid token return changeset" do
    user = fixture(:user)
    assert {:error, :not_valid} = Accounts.activate_user(Ecto.UUID.generate, user.id, @activations_attrs)
  end

  test "activate_user/3 token should be conencted to existing user" do
    {_, activation_token} = fixture(:user_with_activation_token)
    assert {:error, :not_valid} = Accounts.activate_user(activation_token.id, Ecto.UUID.generate, @activations_attrs)
  end

  test "activate_user/3 password should have correct confirmation" do
    {user, activation_token} = fixture(:user_with_activation_token)
    assert {:error, changeset} = Accounts.activate_user(activation_token.id, user.id, %{@activations_attrs | password_confirmation: "other"})
    assert "does not match confirmation" in errors_on(changeset).password_confirmation
  end

  # test "update_user/2 with valid data updates the user" do
  #   user = fixture(:user)
  #   assert {:ok, user} = Accounts.update_user(user, @update_attrs)
  #   assert %User{} = user
  # end
  #
  # test "update_user/2 with invalid data returns error changeset" do
  #   user = fixture(:user)
  #   assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
  #   assert user == Accounts.get_user!(user.id)
  # end
  #
  test "delete_user/1 deletes the user" do
    user = fixture(:user)
    assert {:ok, %User{}} = Accounts.delete_user(user)
    assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
  end

  test "change_user/1 returns a user changeset" do
    user = fixture(:user)
    assert %Ecto.Changeset{} = Accounts.change_user(user)
  end

  test "authenticate_user/2 return user for valid params" do
    user = fixture(:user_activated)
    assert {:ok, logged_user} = Accounts.authenticate_user(@login_attrs.email, @login_attrs.password)
    assert user == logged_user
  end

  test "authenticate_user/2 return not_activated error for not activated user" do
    user = fixture(:user)
    assert {:error,  :user_not_activated} == Accounts.authenticate_user(@login_attrs.email, @login_attrs.password)
  end

end
