defmodule Kraal.Accounts.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %Kraal.Accounts.User{
          email: FakerElixir.Internet.email,
          roles: %Kraal.Accounts.User.Roles{}
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
        %Kraal.Accounts.User{
          email: FakerElixir.Internet.email,
          password: FakerElixir.Internet.password(:normal)
        }
      end

      def user_hash_password(user) do
        %{user | password_hash: Comeonin.Argon2.hashpwsalt(user.password)}
      end

      def user_activate(%Kraal.Accounts.User{} = user) do
        %{user | active: true}
      end

      def user_confirm(%Kraal.Accounts.User{} = user) do
        %{user | confirmed_at: DateTime.utc_now()}
      end

      def user_admin(%Kraal.Accounts.User{} = user) do
        %{user | roles: %Kraal.Accounts.User.Roles{admin: true}}
      end

      def user_active_scout(%Kraal.Accounts.User{} = user) do
        %{user | roles: %Kraal.Accounts.User.Roles{active_scout: true}}
      end

      def user_cms_admin(%Kraal.Accounts.User{} = user) do
        %{user | roles: %Kraal.Accounts.User.Roles{cms_admin: true}}
      end

    end
  end
end
