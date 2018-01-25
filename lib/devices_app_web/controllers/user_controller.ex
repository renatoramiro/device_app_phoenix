defmodule DevicesAppWeb.UserController do
  use DevicesAppWeb, :controller

  alias DevicesApp.User
  alias DevicesApp.Repo

  plug :scrub_params, "user" when action in [:create]
  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  def show(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    conn
    # |> put_resp_header("Autorization", "Bearer #{refresh_token(conn)}")
    |> render("show.json", user: current_user)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = %User{} |> User.registration_changeset(user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render("show.json", user: user)
    end
  end
end