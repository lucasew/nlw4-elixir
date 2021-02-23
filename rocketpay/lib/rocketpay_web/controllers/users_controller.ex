defmodule RocketpayWeb.UsersController do
  use RocketpayWeb, :controller

  def create(conn, params) do
    params
    |> Rocketpay.create_user()
    |> handle_response(conn)
  end

  defp handle_response({:ok, user}, conn) do
      conn
      |> put_status(:created)
      |> render("create.json", user: user)
  end
  defp handle_response({:error, err}, conn) do
    conn
    |> put_status(:bad_request)
    |> put_view(RocketpayWeb.ErrorView)
    |> render("400.json", result: err)
  end
end
