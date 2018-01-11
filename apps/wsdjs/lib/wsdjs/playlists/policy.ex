defmodule Wsdjs.Playlists.Policy do
    def can?(_, _), do: {:error, :unauthorized}
end
