defmodule Kraal.Web.ProfileController do
  use Kraal.Web, :controller
  require Logger

  alias Kraal.Accounts

  plug :check_is_token_valid when action in  [:validate_activation_token, :activate_account]

  def validate_activation_token(conn, %{"user_id" => user_id, "token_id" => activation_token_id}) do
      Logger.info "Activation token: #{activation_token_id} valid for user: #{user_id}"
      changeset = Accounts.change_user(%Kraal.Accounts.User{})
      render(conn, "activate.html", changeset: changeset)
  end

  def activate_account(conn, %{"user_id" => user_id, "token_id" => activation_token_id, "user"=>user}) do
    case Accounts.activate_user(activation_token_id, user_id, user) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, "User activated")
        |> redirect(to: profile_path(conn, :show))
      {:error, changeset} ->
          render(conn, "activate.html", changeset: changeset)
    end
  end

  def show(conn, _params) do
    render(conn, :show, user: Guardian.Plug.current_resource(conn))
  end

  def edit(conn, _params) do

  end

  defp check_is_token_valid(conn, second) do
    %{"user_id" => user_id, "token_id" => activation_token_id} = conn.path_params
    case Accounts.validate_activation_token(activation_token_id, user_id) do
      {:ok, token} ->
        conn
        |> assign(:token, token)
      _ ->
        Logger.warn "Activation token: #{activation_token_id} invalid for user: #{user_id}"
        conn
        |> put_flash(:error, gettext("Not valid token"))
        |> redirect(to: "/")
        |> halt
      end
  end
end
