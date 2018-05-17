defmodule WsdjsWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL

      alias Wsdjs.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import WsdjsWeb.Router.Helpers
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Wsdjs.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Wsdjs.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Wsdjs.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    {:ok, session: session}
  end
end