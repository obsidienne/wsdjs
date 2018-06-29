defmodule Wsdjs.Jobs.RadioStreamed do
  import Ecto.Query, warn: false

  @radioking_api_uri_list 'https://www.radioking.com/widgets/api/v1/radio/84322/track/ckoi?limit=10'
  @expected_fields ~w(title artist cover started_at end_at duration)
  def call(_args \\ []) do
    case HTTPoison.get(@radioking_api_uri_list) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        songs =
          body
          |> Poison.decode!()
          |> Enum.map(fn song ->
            Map.take(song, @expected_fields)
          end)

        previous_songs = ConCache.get(:wsdjs_cache, "streamed_songs")
        notify(songs, previous_songs)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found :(")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.puts(reason)
    end
  end

  defp notify(songs, songs), do: nil

  defp notify(songs, _) do
    # credo:disable-for-lines:1
    IO.inspect(songs)
    ConCache.put(:wsdjs_cache, "streamed_songs", songs)
    ConCache.delete(:wsdjs_cache, "streamed_songs_json")

    Phoenix.PubSub.broadcast(WsdjsWeb.PubSub, "radio:streamed", :new_streamed_song)
  end
end
