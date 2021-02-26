defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true
  alias Rocketpay.{Account, User}

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "Lucas",
        password: "123456",
        nickname: "lucasew",
        email: "notarealemail@gmail.com",
        age: 69
      }
      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)
      conn = put_req_header(conn, "authorization", "Basic YmFuYW5hOm5hbmljYTEyMw==")
      {:ok, conn: conn, account_id: account_id}
    end
    test "when all params are valid, make the deposit", %{conn: conn, account_id: account_id} do
      params = %{"value" => "50.00"}
      response = conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:ok)
      assert response == %{
        "account" => %{
          "balance" => "50.00",
          "id" => account_id
        },
        "message" => "Balance changes successfully"
      }
    end
    test "when there are invalid params, returns an error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "banana"}
      response = conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:bad_request)
      assert response == %{
        "errors" => %{
          "balance" => [
            "is invalid"
          ]
        },
        "status" => "Bad request"
      }
    end
  end
end
