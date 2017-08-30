defmodule KraalWeb.Admin.InvitationController do
  @moduledoc """
  Handle invitation actions.

  Handle the following actions:

  * new - render the send invitation form.
  * create - generate and send the invitation token.
  * resend - resend an invitation token email
  """
  use CoherenceWeb, :controller
  use Timex

  import Ecto.Changeset

  alias Coherence.{Config, Messages}
  alias Kraal.Coherence.Schemas

  require Logger

  plug Coherence.ValidateOption, :invitable
  plug :scrub_params, "user" when action in [:create_user]
  plug :layout_view, view: Admin.InvitationView, caller: __MODULE__

  @type schema :: Ecto.Schema.t
  @type conn :: Plug.Conn.t
  @type params :: Map.t

  def index(conn, _params) do
    invitations = Schemas.list_invitation
    render(conn, "index.html", invitations: invitations)
  end

  @doc """
  Render the new invitation form.
  """
  @spec new(conn, params) :: conn
  def new(conn, _params) do
    changeset = Schemas.change_invitation()
    render(conn, "new.html", changeset: changeset)
  end

  @doc """
  Generate and send an invitation token.

  Creates a new invitation token, save it to the database and send
  the invitation email.
  """
  @spec create(conn, params) :: conn
  def create(conn, %{"invitation" =>  invitation_params} = params) do
    email = invitation_params["email"]
    changeset = Schemas.change_invitation invitation_params
    # case repo.one from u in user_schema, where: u.email == ^email do
    case Schemas.get_user_by_email email do
      nil ->
        token = random_string 48
        url = router_helpers().invitation_url(conn, :edit, token)
        changeset = put_change(changeset, :token, token)
        do_insert(conn, changeset, url, email)
      _ ->
        changeset =
          changeset
          |> add_error(:email, Messages.backend().user_already_has_an_account())
          |> struct(action: true)
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp do_insert(conn, changeset, url, email) do
    case Schemas.create changeset do
      {:ok, invitation} ->

        send_user_email :invitation, invitation, url
        conn
        |> put_flash(:info, Messages.backend().invitation_sent())
        |> redirect(to: KraalWeb.Router.Helpers.admin_invitation_path(conn, :index))
      {:error, changeset} ->
        {conn, changeset} =
          case Schemas.get_by_invitation email: email do
            nil -> {conn, changeset}
            invitation ->
              {assign(conn, :invitation, invitation),
                add_error(changeset, :email,
                  Messages.backend().invitation_already_sent())}
          end
        render(conn, "new.html", changeset: changeset)
    end
  end

  @doc """
  Resent an invitation

  Resent the invitation based on the invitation's id.
  """
  @spec resend(conn, params) :: conn
  def resend(conn, %{"id" => id} = params) do
    conn =
      case Schemas.get_invitation id do
        nil ->
          put_flash(conn, :error, Messages.backend().cant_find_that_token())
        invitation ->
          send_user_email :invitation, invitation,
            router_helpers().invitation_url(conn, :edit, invitation.token)
          put_flash conn, :info, Messages.backend().invitation_sent()
      end
    redirect_to(conn, :invitation_resend, params)
  end
end
