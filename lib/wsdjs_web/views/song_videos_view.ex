defmodule WsdjsWeb.SongVideosView do
  use WsdjsWeb, :view

  alias Wsdjs.Happenings

  def list_events do
    events = Happenings.list_events()
    Enum.map(events, &{&1.name, &1.id})
  end
end
