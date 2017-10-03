defmodule Kraal.AccountsTest.User do
  use Kraal.DataCase

  alias Kraal.Accounts
  alias Kraal.Accounts.User

  import Kraal.Factory

  @user_attrs %{email: FakerElixir.Internet.email, password: FakerElixir.Internet.password(:normal)}

  describe "change user/1" do
    test "returns a user changeset" do
      user = build(:user)
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "list_user/0" do
    test "returns all user" do
      users = insert_list( 5, :user)
      assert Accounts.list_user() == users
    end
  end

  describe "register_user/1" do
    test "create new user with empty profile and roles" do
      user_params = string_params_for(:user_register)
      assert {:ok, %User{} = user} = Accounts.register_user(user_params)
      refute is_nil user.password_hash
      refute is_nil user.confirmation_token
      refute is_nil user.profile
      # refute is_nil user.roles
    end

    test "require email" do
      user_params = string_params_for(:user_register, %{email: ""})
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.register_user(user_params)
      assert %{email: ["can't be blank"]} = errors_on(changeset)
      refute changeset.valid?
    end

    test "require password" do
      user_params = string_params_for(:user_register, %{password: "", password_confirmation: ""})
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.register_user(user_params)
      assert %{password: ["can't be blank"]} = errors_on(changeset)
      refute changeset.valid?
    end

    test "password must match" do
      user_params = string_params_for(:user_register, %{password_confirmation: FakerElixir.Internet.password(:weak)})
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.register_user(user_params)
      assert %{password_confirmation: ["does not match confirmation"]} = errors_on(changeset)
      refute changeset.valid?
    end

    test "email has be uniq" do
      insert(:user, %{email: @user_attrs.email})
      user_params = string_params_for(:user_register, %{email: @user_attrs.email})
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.register_user(user_params)
      assert %{email: ["has already been taken"]} = errors_on(changeset)
      refute changeset.valid?
    end
  end

  describe "login/2" do

    test "should return user with profile for success" do
      %User{email: email, password: password} = insert(:user_login)
      user_params = string_params_for(:user_login, %{email: email, password: password})
      assert {:ok, %User{email: ^email}} = Accounts.login(user_params)
    end

    test "should return error for deleted" do
      %User{email: email, password: password} = build(:user_login)
      |> user_deleted
      |> insert
      user_params = string_params_for(:user_login, %{email: email, password: password})
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.login(user_params)
      assert %{user: ["not exist"]} = errors_on(changeset)
      refute changeset.valid?
    end

    test "login/2 should return error for not confirmed user" do
      %User{email: email, password: password} = build(:user_login)
      |> user_not_confirmed
      |> insert
      user_params = string_params_for(:user_login, %{email: email, password: password})
      assert  {:error,%Ecto.Changeset{} = changeset} = Accounts.login(user_params)
      assert %{user: ["not confirmed"]} = errors_on(changeset)
      refute changeset.valid?
    end

    test "login/2 should return error for wrong password" do
      %User{email: email} = insert(:user_login)
      user_params = string_params_for(:user_login, %{email: email, password: @user_attrs.password})
      assert  {:error, %Ecto.Changeset{} = changeset} = Accounts.login(user_params)
      assert %{user: ["invalid password"]} = errors_on(changeset)
      refute changeset.valid?
    end
  end
end
