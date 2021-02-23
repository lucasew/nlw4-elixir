defmodule RocketpayWeb.UsersView do
  def render("create.json", %{user: %{id: id, name: name, nickname: nickname}}) do
    %{
      message: "User created",
      data: %{
        id: id,
        name: name,
        nickname: nickname
      }
    }
  end
end
