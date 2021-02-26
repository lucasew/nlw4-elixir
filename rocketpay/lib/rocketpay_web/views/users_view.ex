defmodule RocketpayWeb.UsersView do
  alias RocketpayWeb.AccountsView
  def render("create.json", %{user: user}) do
    %{
      message: "User created",
      data: handle_entity(user)
    }
  end
  def handle_entity(%{
    account: account,
    id: id,
    name: name,
    nickname: nickname
  }) do
    %{
      account: AccountsView.handle_entity(account),
      id: id,
      name: name,
      nickname: nickname
    }
  end

  def handle_entity(nil), do: nil

end
