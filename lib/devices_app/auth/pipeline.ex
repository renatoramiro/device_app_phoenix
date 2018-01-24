defmodule DevicesApp.Auth.Pipeline do
  import Phoenix.Controller
  import Plug.Conn

  def init(opts), do: opts
  def call(conn, _opts) do
    conn = conn
    |> put_resp_header("Autorization", "Bearer #{refresh_token(conn)}")
    conn
  end

  defp refresh_token(conn) do
    jwt = Guardian.Plug.current_token(conn)
    {:ok, old_token, {new_token, _new_claim}} = DevicesApp.Auth.Guardian.refresh(jwt)
    new_token
  end
end