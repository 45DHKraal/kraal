defmodule Kraal.Web.ProfileController do
  use Kraal.Web, :controller
  require Logger

  alias Kraal.Accounts

  def validate_activation_token(conn, %{"user_id" => user_id, "token_id" => activation_token_id}) do
    case Accounts.validate_activation_token(activation_token_id, user_id) do
      {:ok, token} ->
        Logger.info "Activation token: #{activation_token_id} valid for user: #{user_id}"
        changeset = Accounts.change_user(%Kraal.Accounts.User{})
        require IEx
        IEx.pry
        render(conn, "activate.html", changeset: changeset, token: token)
      _ ->
        Logger.warn "Activation token: #{activation_token_id} invalid for user: #{user_id}"
        conn
        |> put_flash(:error, gettext("Not valid token"))
        |> redirect(to: "/")
        |> halt
      end
  end
  def activate_account(conn, %{"user_id" => user_id, "token_id" => activation_token_id, "user"=>user}) do
    case Accounts.validate_activation_token(activation_token_id, user_id) do
      {:ok, token} ->

      _ ->
        Logger.warn "Activation token: #{activation_token_id} invalid for user: #{user_id}"
        conn
        |> put_flash(:error, gettext("Not valid token"))
        |> redirect(to: "/")
        |> halt
      end
  end

  def show(conn, _params) do

  end

  def edit(conn, _params) do

  end

end
