defmodule WsdjsApi.Musics.Opinion do
  use Ecto.Schema
  
  schema "musics_opinions" do
    field :kind, :string

    timestamps()
  end
end
