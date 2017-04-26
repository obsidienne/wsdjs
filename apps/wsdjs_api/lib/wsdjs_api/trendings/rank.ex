defmodule WsdjsApi.Trendings.Rank do
  use Ecto.Schema
  
  schema "trendings_ranks" do
    field :likes, :integer
    field :votes, :integer
    field :bonus, :integer
    field :position, :integer

    timestamps()
  end
end
