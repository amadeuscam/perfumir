defmodule PerfumirApi.Users.User do
  alias PerfumirApi.Accounts
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :full_name, :string
    field :gender, :string
    field :biography, :string
    belongs_to :account, Accounts.Account

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:account_id, :full_name, :gender, :biography])
    |> validate_required([:account_id])
  end
end
