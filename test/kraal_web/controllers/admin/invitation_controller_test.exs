defmodule KraalWeb.Admin.InvitationControllerTest do
  use KraalWeb.ConnCase

  alias Kraal.Admin

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:invitation) do
    {:ok, invitation} = Admin.create_invitation(@create_attrs)
    invitation
  end

  describe "index" do
    test "lists all invitations", %{conn: conn} do
      conn = get conn, admin_invitation_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Invitations"
    end
  end

  describe "new invitation" do
    test "renders form", %{conn: conn} do
      conn = get conn, admin_invitation_path(conn, :new)
      assert html_response(conn, 200) =~ "New Invitation"
    end
  end

  describe "create invitation" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, admin_invitation_path(conn, :create), invitation: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == admin_invitation_path(conn, :show, id)

      conn = get conn, admin_invitation_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Invitation"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, admin_invitation_path(conn, :create), invitation: @invalid_attrs
      assert html_response(conn, 200) =~ "New Invitation"
    end
  end

  describe "edit invitation" do
    setup [:create_invitation]

    test "renders form for editing chosen invitation", %{conn: conn, invitation: invitation} do
      conn = get conn, admin_invitation_path(conn, :edit, invitation)
      assert html_response(conn, 200) =~ "Edit Invitation"
    end
  end

  describe "update invitation" do
    setup [:create_invitation]

    test "redirects when data is valid", %{conn: conn, invitation: invitation} do
      conn = put conn, admin_invitation_path(conn, :update, invitation), invitation: @update_attrs
      assert redirected_to(conn) == admin_invitation_path(conn, :show, invitation)

      conn = get conn, admin_invitation_path(conn, :show, invitation)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, invitation: invitation} do
      conn = put conn, admin_invitation_path(conn, :update, invitation), invitation: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Invitation"
    end
  end

  describe "delete invitation" do
    setup [:create_invitation]

    test "deletes chosen invitation", %{conn: conn, invitation: invitation} do
      conn = delete conn, admin_invitation_path(conn, :delete, invitation)
      assert redirected_to(conn) == admin_invitation_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, admin_invitation_path(conn, :show, invitation)
      end
    end
  end

  defp create_invitation(_) do
    invitation = fixture(:invitation)
    {:ok, invitation: invitation}
  end
end
