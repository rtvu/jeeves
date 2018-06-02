defmodule JeevesWeb.Router do
  use JeevesWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", JeevesWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", HomeController, :index)
    get("/sign_in", SessionController, :new)
    post("/sign_in", SessionController, :create)
    delete("/sign_out", SessionController, :delete)
  end

  # Other scopes may use custom stacks.
  # scope "/api", JeevesWeb do
  #   pipe_through :api
  # end
end
