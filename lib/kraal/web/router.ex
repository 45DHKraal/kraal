defmodule Kraal.Web.Router do
  use Kraal.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Kraal.Web.Plugs.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :browser_session do
    plug Guardian.Plug.VerifySession # looks in the session for the token
    plug Guardian.Plug.LoadResource
  end

  pipeline :authenticated do
    plug Guardian.Plug.EnsureAuthenticated, handler: Kraal.Web.Handler
  end

  pipeline :admin do
    plug Kraal.Web.Plugs.Admin
    plug :put_layout, {Kraal.Web.LayoutView, "admin.html"}
  end

  scope "/", Kraal.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    scope "/login" do
        get "/", SessionController, :new
        post "/", SessionController, :create
    end

    scope "/activate/:token_id/:user_id" do
      get "/", ProfileController, :validate_activation_token
      post "/", ProfileController, :activate_account
    end
  end


  scope "/", Kraal.Web do
    pipe_through [:browser, :browser_session, :authenticated]
    resources "/profile", ProfileController, singleton: true, only: [:show, :edit]
  end

  scope "/admin", Kraal.Web.Admin, as: :admin do
    pipe_through [:browser, :browser_session, :admin]
    resources "/users", UserController
  end

  if Mix.env == :dev do
    forward "/sent_emails", Bamboo.EmailPreviewPlug
  end
  # Other scopes may use custom stacks.
  # scope "/api", Kraal.Web do
  #   pipe_through :api
  # end
end
