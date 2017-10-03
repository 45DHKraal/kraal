defmodule Kraal.Accounts.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %Kraal.Accounts.User{
          email: FakerElixir.Internet.email,
          roles: %Kraal.Accounts.User.Roles{},
          confirmed_at: DateTime.utc_now()
        }
      end

      def user_register_factory do
        password = FakerElixir.Internet.password(:normal)
        %Kraal.Accounts.User{
          email: FakerElixir.Internet.email,
          password: password,
          password_confirmation: password
        }
      end

      def user_login_factory do
        user_factory
        |> Map.put(:password, FakerElixir.Internet.password(:normal))
        |> user_hash_password
      end

      def user_hash_password(user) do
        %{user | password_hash: Comeonin.Argon2.hashpwsalt(user.password)}
      end

      def user_deleted(%Kraal.Accounts.User{} = user) do
        %{user | deleted_at: DateTime.utc_now()}
      end

      def user_not_confirmed(%Kraal.Accounts.User{} = user) do
        %{user | confirmed_at: nil}
      end

      def user_add_role(%Kraal.Accounts.User{} = user, role) do
        %{user | roles: Map.put(%Kraal.Accounts.User.Roles{}, role, true)}
      end

    end
  end
end
