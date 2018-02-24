defmodule DevicesAppWeb.Router do
  use DevicesAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug Guardian.Plug.Pipeline, module: DevicesApp.Auth.Guardian,
                             error_handler: DevicesApp.Auth.ErrorHandler
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  pipeline :set_token do
    plug DevicesApp.Auth.Pipeline
  end
  
  scope "/api", DevicesAppWeb do
    pipe_through :api

    post "/signin", SessionController, :create
    post "/register", UserController, :create
  end

  scope "/api", DevicesAppWeb do
    pipe_through [:api, :api_auth, :set_token]

    get "/me", UserController, :show
    delete "/logout", SessionController, :delete
  end
end
