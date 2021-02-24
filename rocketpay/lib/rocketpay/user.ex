defmodule Rocketpay.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rocketpay.Account

  @primary_key {:id, :binary_id, autogenerate: true}
  @required_params [:name, :age, :email, :password_hash, :nickname]

  schema "users" do
    field :name, :string
    field :age, :integer
    field :email, :string
    field :password, :string, virtual: true # não salva no banco
    field :password_hash, :string
    field :nickname, :string
    has_one :account, Account
    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params ++ [:password]) # mapeia, tipo values do joi
    |> validate_length(:password, min: 6)
    |> put_password_hash()
    |> validate_number(:age, greater_than_or_equal_to: 18)
    # TODO: Better email regexp
    |> validate_format(:email, ~r/@/)
    |> unique_constraint([:email])
    |> unique_constraint([:nickname])
    |> validate_required(@required_params) # valida se os campos existem
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    changeset
    |> change(Bcrypt.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
