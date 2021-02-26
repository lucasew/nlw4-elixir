defmodule Rocketpay.Users.CreateTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.User
  alias Rocketpay.Users.Create

  describe "call/1" do
    test "when all params are valid, returns an user" do
      params = %{
        name: "Lucas",
        password: "123456",
        nickname: "lucasew",
        email: "notarealemail@gmail.com",
        age: 69
      }
      {:ok, %User{id: user_id}} = Create.call(params)
      user = Repo.get(User, user_id)
      assert %User{name: "Lucas", age: 69, id: ^user_id} = user
    end
  end
  test "when there are invalid params, returns an error" do
      params = %{
        name: "Lucas",
        # password: "123456",
        nickname: "lucasew",
        email: "notarealemail@gmail.com",
        age: 6
      }
      {:error, changeset} = Create.call(params)
      assert %{
        age: ["must be greater than or equal to 18"],
        password_hash: ["can't be blank"]
      } = errors_on(changeset)
  end
end
