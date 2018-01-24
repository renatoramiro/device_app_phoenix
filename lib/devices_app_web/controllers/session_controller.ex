defmodule DevicesAppWeb.SessionController do
  use DevicesAppWeb, :controller

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  plug :scrub_params, "session" when action in [:create]

  alias DevicesApp.{User, Repo}

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    user = Repo.get_by(User, email: email)
    result = cond do
      user && checkpw(password, user.password_hash) ->
        new_conn = login(conn, user)
        jwt = Guardian.Plug.current_token(new_conn)
        claims = Guardian.Plug.current_claims(new_conn)
        exp = Map.get(claims, "exp")
        {:ok, new_conn}
      user ->
        {:error, :unauthorized, conn}
      true ->
        {:error, :not_found, conn}
    end

    case result do
      {:ok, new_conn} ->
        new_conn
        |> put_resp_header("X-Delivered-By", "Device App")
        |> put_resp_header("Authorization", "Bearer #{jwt}")
        |> put_resp_header("x-expires", to_string(exp))
        |> render("login.json", user: user, jwt: jwt)
      {:error, _reason, conn} ->
        conn
        |> send_resp(_reason, "")
        |> halt()
    end
  end

  defp login(conn, user) do
    conn
    |> DevicesApp.Auth.Guardian.Plug.sign_in(user)
  end

  def delete(conn, _) do
    conn
    |> logout()
    |> send_resp(:no_content, "")
  end

  defp logout(conn) do
    jwt = Guardian.Plug.current_token(conn)
    claims = Guardian.Plug.current_claims(conn)
    Guardian.revoke(jwt, claims)
    render(conn, "logout.json")
  end
end