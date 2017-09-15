defmodule KraalWeb.Router do
  use KraalWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end
  pipeline :admin do
    # plug Kraal.Web.Plugs.Admin
    plug :put_layout, {KraalWeb.Admin.LayoutView, "admin.html"}
  end
  pipeline :api do
    plug :accepts, ["json"]
  end
  scope "/", KraalWeb do
    pipe_through :browser
    # Use the default browser stack
    get "/", PageController, :index
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
