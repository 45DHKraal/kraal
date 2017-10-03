defmodule KraalWeb.Router do
  use KraalWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Guardian.Plug.Pipeline, module: Kraal.Guardian,
                             error_handler: KraalWeb.Plugs.AuthErrorHandler

    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource, allow_blank: true
  end

  pipeline :admin do
    plug Guardian.Plug.EnsureAuthenticated
    plug KraalWeb.Plugs.RoleChecker, only: :admin
    plug :put_layout, {KraalWeb.Admin.LayoutView, "admin.html"}
  end

  pipeline :panel do
    plug Guardian.Plug.EnsureAuthenticated
    plug :put_layout, {KraalWeb.Panel.LayoutView, "panel.html"}
  end
  pipeline :api do
    plug :accepts, ["json"]
  end
  scope "/", KraalWeb do
    pipe_through :browser
    # Use the default browser stack
    get "/", PageController, :index

    resources "/login", SessionController, only: [:new, :create], singleton: true
    resources "/logout", SessionController, only: [:destroy], singleton: true
    resources "/register", RegistrationController, only: [:new, :create]
    resources "/posts", PostController, only: [:index, :show], param: "slug"
  end

  scope "/panel", KraalWeb.Panel, as: :panel do
      pipe_through [:browser, :panel]

      get "/", DashboardController, :index
      resources "/pages", PostController
      resources "/posts", PageController
    end
  scope "/admin", KraalWeb.Admin, as: :admin do
    pipe_through [:browser, :admin]
    get "/", DashboardController, :index
    resources "/users", UserController
  end
  # Other scopes may use custom stacks.
  # scope "/api", KraalWeb do
  #   pipe_through :api
  # end
  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end
end
