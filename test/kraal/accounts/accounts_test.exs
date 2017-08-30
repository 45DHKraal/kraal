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
end
