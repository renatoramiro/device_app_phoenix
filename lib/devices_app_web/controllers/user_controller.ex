require IEx

defmodule DevicesAppWeb.UserController do
  use DevicesAppWeb, :controller

  alias DevicesApp.{User, Repo}

  plug :scrub_params, "user" when action in [:create]
  # plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  def show(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    conn
    |> render("show.json", user: current_user)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = %User{} |> User.registration_changeset(user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("show.json", user: %{id: user.id, name: user.name, email: user.email})
      {:error, changeset} ->
        IO.inspect changeset
        conn
        |> send_resp(409, "{\"success\":false, \"message\": \"Something wrong happened! :(\"}")
        |> halt()
    end
  end
end