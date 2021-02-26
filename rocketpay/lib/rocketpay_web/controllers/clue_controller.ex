defmodule RocketpayWeb.ClueController do
  use RocketpayWeb, :controller
  alias Rocketpay.{User, Repo}

  action_fallback RocketpayWeb.FallbackController
  def index(conn, params) do
    data = Repo.all(User) |> Repo.preload(:account)
    structured_data = data |> Enum.map(fn item ->
      RocketpayWeb.UsersView.handle_entity(item)
    end)
    conn
    |> put_status(:ok)
    |> json(%{
      params: params,
      users: structured_data
    })
  end
end
