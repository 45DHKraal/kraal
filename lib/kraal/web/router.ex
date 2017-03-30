defmodule Kraal.Web.Router do
  use Kraal.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :browser_session do
    plug Guardian.Plug.VerifySession # looks in the session for the token
    plug Guardian.Plug.LoadResource
  end

  pipeline :admin do
    plug Kraal.Plugs.Admin
    plug :put_layout, {Kraal.Web.LayoutView, "admin.html"}
  end

  scope "/", Kraal.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/activate/:token/:user", ProfileController, :activate

    scope "/profile" do
      get "/", ProfileController, :show
      get "/edit", ProfileController, :edit
      post "/edit", ProfileController, :update
    end
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
