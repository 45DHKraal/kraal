defmodule Kraal.Web.ProfileController do
  use Kraal.Web, :controller

  alias Kraal.Accounts

  def activate(conn, {"user"=>user_id, "token"=>activation_token_id}) do
    case activate_user(activation_token_id, user_id) do
    else ->
      
    end
  end

  def show(conn, _params) do

  end

  def edit(conn, _params) do

  end

end
