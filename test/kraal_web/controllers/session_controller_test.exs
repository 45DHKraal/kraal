defmodule KraalWeb.SessionControllerTest do
  use KraalWeb.ConnCase

  alias Kraal.Accounts

  import Kraal.Factory
  import FakerElixir.Internet

  @user_data %{email: email(), password: password(:normal)}

  describe "new session" do
    test "renders form", %{conn: conn} do
      conn = get conn, session_path(conn, :new)
      assert html_response(conn, 200)
    end
  end

  describe "create session" do
    setup :create_valid_user

    test "redirects to homepage when user sucessful login", %{conn: conn} do
      conn = post conn, session_path(conn, :create), user: @user_data
      assert redirected_to(conn) == page_path(conn, :index)

      conn = get conn, page_path(conn, :index)

      assert get_flash(conn, :info) =~ "Session created successfully."
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, session_path(conn, :create), user: %{email: @user_data.email, password: password(:normal)}
      assert %Ecto.Changeset{valid?: false} = conn.assigns.changeset
      assert html_response(conn, 200)
    end

    def create_valid_user(_params) do
      user = build(:user, %{email: @user_data.email, password: @user_data.password})
      |> user_hash_password
      |> user_confirm
      |> user_activate
      |> insert
      {:ok, user: user}
    end

  end


  # describe "delete session" do
  #
  #   test "deletes chosen session", %{conn: conn, session: session} do
  #     conn = delete conn, session_path(conn, :delete, session)
  #     assert redirected_to(conn) == session_path(conn, :index)
  #     assert_error_sent 404, fn ->
  #       get conn, session_path(conn, :show, session)
  #     end
  #   end
  # end

end
