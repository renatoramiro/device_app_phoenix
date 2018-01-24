defmodule DevicesAppWeb.UserView do
  use DevicesAppWeb, :view

  def render("show.json", %{user: user}) do
    %{_id: user.id, email: user.email, name: user.name}
  end
end