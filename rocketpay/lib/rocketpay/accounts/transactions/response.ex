defmodule Rocketpay.Accounts.Transactions.Response do
  alias Rocketpay.Account

  defstruct [:from, :to]

  def build(%Account{} = from, %Account{}  = to) do
    %__MODULE__{
      from: from,
      to: to
    }
  end
end
