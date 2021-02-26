defmodule RocketpayWeb.AccountsView do
  def render("update.json", %{account: account}) do
    %{
      message: "Balance changes successfully",
      account: handle_entity(account)
    }
  end

  def render("transaction.json", %{
    transaction: %{
      to: to_account,
      from: from_account
      # value: value
    }
  }) do
   %{
     message: "Transaction done succesfully",
     transaction: %{
       from: handle_entity(from_account),
       to: handle_entity(to_account)
     }
   }
  end

  def handle_entity(%{id: account_id, balance: account_balance}) do
    %{
      id: account_id,
      balance: account_balance
    }
  end
  def handle_entity(nil), do: nil

end
