defmodule KraalWeb.Router do
  use KraalWeb, :router
  use Coherence.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session
  end

  pipeline :admin do
    # plug Kraal.Web.Plugs.Admin
    plug :put_layout, {KraalWeb.Admin.LayoutView, "admin.html"}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", KraalWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    coherence_routes()
  end

  scope "/admin", KraalWeb.Admin, as: :admin do
    pipe_through [:browser, :admin]

    get "/", DashboardController, :index
    resources "/users", UserController
    get "/invitations/resend", InvitationController, :resend
    resources "/invitations", InvitationController, only: [:index, :new, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", KraalWeb do
  #   pipe_through :api
  # end

  if Mix.env == :dev do
    scope "/dev" do
      pipe_through [:browser]

      forward "/mailbox", Plug.Swoosh.MailboxPreview, [base_path: "/dev/mailbox"]
    end
  end
end
