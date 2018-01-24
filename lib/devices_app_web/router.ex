defmodule DevicesAppWeb.Router do
  use DevicesAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug CORSPlug
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

    resources("/sessions", SessionController, only: [:create])
    options   "/sessions", SessionController, :options
  end

  scope "/api", DevicesAppWeb do
    pipe_through [:api, :api_auth, :set_token]

    resources("/users", UserController, only: [:show, :create])
    options   "/users", UserController, :options
    options   "/users/:id", UserController, :options
    resources("/sessions", SessionController, only: [:delete])
  end
end