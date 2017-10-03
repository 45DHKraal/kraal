defmodule Kraal.GuardianTest do
  use Kraal.DataCase

  alias Kraal.Accounts.Users
  alias Kraal.Guardian

  import Kraal.Factory
  import FakerElixir.Internet

  @user_data %{email: email(), password: password(:normal)}

  describe("#subject_for_token for %User{} given") do
    setup :create_user

    test "returns User:<id>", %{user: user} do
      assert Guardian.subject_for_token(user, nil) == {:ok, "User:#{user.id}"}
    end
  end

  describe("#subject_for_token for unknown resource given") do
    test "returns error" do
      assert Guardian.subject_for_token(%{some: "thing"}, nil) == {:error, :unknown_resource}
    end
  end

  describe("#resource_from_claims for 'User:<valid_id>' given") do
  setup :create_user

  test "returns {:ok, %User{}} tuple", %{user: user} do
    assert Guardian.resource_from_claims(%{"sub" => "User:" <> to_string(user.id) }) == {:ok, user}
  end

end

describe("#resource_from_claims for 'User:<invalid_id>' given") do

  test "returns {:error, :invalid_id} tuple" do
    assert Guardian.resource_from_claims(%{"sub" => "User:a9sd9"}) == {:error, :invalid_id}
    assert Guardian.resource_from_claims(%{"sub" => "User:123ace"}) == {:error, :invalid_id}
    assert Guardian.resource_from_claims(%{"sub" => "User:"}) == {:error, :invalid_id}
  end

end

describe("#resource_from_claims for 'User:<non_existing>' given") do

  test "returns {:error, :no_result} tuple" do
    assert Guardian.resource_from_claims(%{"sub" => "User:#{to_string(Ecto.UUID.generate())}"}) == {:error, :no_result}
  end

end


describe("#resource_from_claims for other string given") do

  test "returns {:error, :invalid_claims} tuple" do
    assert Guardian.resource_from_claims(%{"sub" => "SampleNoun:123"}) == {:error, :invalid_claims}
  end

end

  def create_user(_params) do
    user = build(:user, %{email: @user_data.email, password: @user_data.password})
    |> user_hash_password
    |> insert
    {:ok, user: Kraal.Accounts.get_user!(user.id)}
  end


end
