defmodule DevicesAppWeb.SessionView do
  use DevicesAppWeb, :view

  def render("show.json", %{user: user}) do
    %{name: user.name, username: user.username}
  end

  def render("login.json", %{user: user, jwt: jwt}) do
    %{success: true, id: user.id, token: jwt}
  end

  def render("logout.json", %{}) do
    %{message: "Successful signed out."}
  end
end