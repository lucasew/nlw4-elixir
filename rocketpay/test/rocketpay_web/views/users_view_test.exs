defmodule RocketpayWeb.UsersViewTest do
  use RocketpayWeb.ConnCase, async: true
  import Phoenix.View

  alias Rocketpay.{Account, User}

  test "renders create.json" do
    params = %{
      name: "Lucas",
      password: "123456",
      nickname: "lucasew",
      email: "notarealemail@gmail.com",
      age: 69
    }
    {:ok, %User{id: user_id, account: %Account{id: account_id}} = user} = Rocketpay.create_user(params)
    response = render(RocketpayWeb.UsersView, "create.json", user: user)
    assert %{
      data: %{
        account: %{
          balance: Decimal.new("0.00"),
          id: account_id
        },
        id: user_id,
        name: "Lucas",
        nickname: "lucasew"
      },
      message: "User created"
    } == response
  end
end
