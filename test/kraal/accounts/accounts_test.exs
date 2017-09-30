defmodule Kraal.AccountsTest do
  use Kraal.DataCase

  alias Kraal.Accounts

  import Kraal.Factory

  describe "profile" do
    alias Kraal.Accounts.Profile

    test "list_profile/0 returns all profile" do
      profiles = insert_list( 5, :profile)
      assert Accounts.list_profile() == profiles
    end

    test "get_profile!/1 returns the profile with given id" do
      profile = insert(:profile)
      assert Accounts.get_profile!(profile.id) == profile
    end

    test "create_profile/1 with valid data creates a profile" do
      assert {:ok, %Kraal.Accounts.Profile{}} = Accounts.create_profile(params_for(:profile))
    end

    test "create_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_profile(params_for(:profile_invalid))
    end

    test "update_profile/2 with valid data updates the profile" do
      profile = insert(:profile)
      assert {:ok, profile} = Accounts.update_profile(profile, %{first_name: FakerElixir.Name.first_name})
      assert %Profile{} = profile
    end

    test "update_profile/2 with invalid data returns error changeset" do
      profile = insert(:profile)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_profile(profile, params_for(:profile_invalid))
      assert profile == Accounts.get_profile!(profile.id)
    end

    test "delete_profile/1 deletes the profile" do
      profile = insert(:profile)
      assert {:ok, %Profile{}} = Accounts.delete_profile(profile)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_profile!(profile.id) end
    end

    test "change_profile/1 returns a profile changeset" do
      profile = build(:profile)
      assert %Ecto.Changeset{} = Accounts.change_profile(profile)
    end
  end

  describe "user" do
    alias Kraal.Accounts.User

    test "change_user/1 returns a user changeset" do
      user = build(:user)
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "list_user/0 returns all user" do
      users = insert_list( 5, :user)
      assert Accounts.list_user() == users
    end

    test "register_user/1 create new user" do
      user_params = string_params_for(:user_register)
      assert {:ok, %User{} = user} = Accounts.register_user(user_params)
      refute is_nil user.password_hash
      refute is_nil user.confirmation_token
    end

    test "register_user/1 require email" do
      user_params = string_params_for(:user_register, %{email: ""})
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.register_user(user_params)
      assert %{email: ["can't be blank"]} = errors_on(changeset)
      refute changeset.valid?
    end

    test "register_user/1 require password" do
      user_params = string_params_for(:user_register, %{password: "", password_confirmation: ""})
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.register_user(user_params)
      assert %{password: ["can't be blank"]} = errors_on(changeset)
      refute changeset.valid?
    end

    test "register_user/1 password must match" do
      user_params = string_params_for(:user_register, %{password_confirmation: FakerElixir.Internet.password(:weak)})
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.register_user(user_params)
      assert %{password_confirmation: ["does not match confirmation"]} = errors_on(changeset)
      refute changeset.valid?
    end

    test "register_user/1 email has be uniq" do
      email = FakerElixir.Internet.email
      insert(:user, %{email: email})
      user_params = string_params_for(:user_register, %{email: email})
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.register_user(user_params)
      assert %{email: ["has already been taken"]} = errors_on(changeset)
      refute changeset.valid?
    end

    test "login/2 should return user with profile for success" do
      email = FakerElixir.Internet.email
      password = FakerElixir.Internet.password(:normal)
      build(:user, %{email: email, password: password})
      |> user_hash_password
      |> user_confirm
      |> user_activate
      |> insert
      user_params = string_params_for(:user_login, %{email: email, password: password})
      assert {:ok, %User{email: ^email}} = Accounts.login(user_params)
    end

    test "login/2 should return error for not active user" do
      email = FakerElixir.Internet.email
      password = FakerElixir.Internet.password(:normal)
      build(:user, %{email: email, password: password})
      |> user_hash_password
      |> user_confirm
      |> insert
      user_params = string_params_for(:user_login, %{email: email, password: password})
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.login(user_params)
      assert %{user: ["not activated"]} = errors_on(changeset)
      refute changeset.valid?
    end

    test "login/2 should return error for not confirmed user" do
      email = FakerElixir.Internet.email
      password = FakerElixir.Internet.password(:normal)
      build(:user_login, %{email: email, password: password})
      |> user_hash_password
      |> insert
      user_params = string_params_for(:user_login, %{email: email, password: password})
      assert  {:error,%Ecto.Changeset{} = changeset} = Accounts.login(user_params)
      assert %{user: ["not confirmed"]} = errors_on(changeset)
      refute changeset.valid?
    end

    test "login/2 should return error for wrong password" do
      email = FakerElixir.Internet.email
      password = FakerElixir.Internet.password(:normal)
      build(:user_login, %{email: email})
      |> user_hash_password
      |> user_confirm
      |> user_activate
      |> insert
      user_params = string_params_for(:user_login, %{email: email, password: password})
      assert  {:error, %Ecto.Changeset{} = changeset} = Accounts.login(user_params)
      assert %{user: ["invalid password"]} = errors_on(changeset)
      refute changeset.valid?
    end


  end
end
