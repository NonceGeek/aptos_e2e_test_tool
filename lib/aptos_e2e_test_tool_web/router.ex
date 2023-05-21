defmodule AptosE2eTestToolWeb.Router do
  use AptosE2eTestToolWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {AptosE2eTestToolWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AptosE2eTestToolWeb do
    pipe_through :browser

#    get "/", PageController, :home
    live "/", ScriptLive.Index, :index
#    live "/scripts/new", ScriptLive.Index, :new
#    live "/scripts/:id/edit", ScriptLive.Index, :edit
#
#    live "/scripts/:id", ScriptLive.Show, :show
#    live "/scripts/:id/show/edit", ScriptLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", AptosE2eTestToolWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:aptos_e2e_test_tool, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AptosE2eTestToolWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
