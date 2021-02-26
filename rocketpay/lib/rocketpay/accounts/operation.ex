defmodule Rocketpay.Accounts.Operation do
  alias Ecto.Multi
  alias Rocketpay.{Account}

  def call(%{"id" => id, "value" => value}, operation) do
    with {:ok, acc_id} <- validate_id(id) do
      operation_name = account_operation_name(operation)
      Multi.new()
      |> Multi.run(operation, fn repo, _changes ->
        get_account(repo, acc_id)
      end)
      |> Multi.run(
        operation_name,
        fn repo, changes ->
          account = Map.get(changes, operation)
          update_balance(repo, account, value, operation)
        end
      )
    end
  end

  defp validate_id(id) do
    case Ecto.UUID.cast(id) do
      {:ok, acc_id} -> {:ok, acc_id}
      :error -> {:error, "Not a valid ID"}
    end
  end

  defp get_account(repo, id) do
    case repo.get(Account, id) do
      nil -> {:error, "Account not found"}
      account -> {:ok, account}
    end
  end

  defp update_balance(repo, account, value, operation) do
    with value <- handle_values(account, value, operation) do
      params = %{balance: value}
      account
      |> Account.changeset(params)
      |> repo.update()
    end
  end

  defp handle_values(%Account{balance: balance}, value, operation) do
    value
    |> Decimal.cast()
    |> handle_cast(balance, operation)
  end

  defp handle_cast({:ok, value}, balance, :deposit), do: Decimal.add(balance, value)
  defp handle_cast({:ok, value}, balance, :withdraw), do: Decimal.sub(balance, value)
  defp handle_cast(:error, _balance, _op), do: {:error, "Invalid deposit value!"}

  defp account_operation_name(operation), do:
    "account_#{Atom.to_string(operation)}" |> String.to_atom()
end
