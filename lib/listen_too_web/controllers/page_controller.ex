defmodule ListenTooWeb.PageController do
  use ListenTooWeb, :controller

  alias ListenTooWeb.Authentication

  def index(conn, _params) do
    # render(conn, "./priv/static/index.html")
    html(conn, File.read!("./priv/static/index.html"))
  end

  # def reccommend(params) do
  #   token = Authentication.get_token()

  #   # https://api.spotify.com/v1/recommendations?seed_artists=4NHQUGzhtTLFvgF5SZesLK&seed_tracks=0c6xIDDpzE81m2q797ordA&min_energy=0.4&min_popularity=50&market=US
  #   # headers = [Authorization: "Bearer #{token}", Accept: "Application/json; Charset=utf-8"]
  #   HTTPoison.get(
  #     "https://api.spotify.com/v1/recommendations?#{build_request(params)}",
  #     headers()
  #   )
  # end

  @valid_types ~w(album artist playlist track show episode)

  def search(conn, %{"types" => _types, "searchString" => ""}) do
    json(conn, %{"success" => false, "message" => "empty search string"})
  end

  def search(conn, %{"types" => _types, "searchString" => nil}) do
    json(conn, %{"success" => false, "message" => "empty search string"})
  end

  def search(conn, %{"types" => types, "searchString" => search_string}) do
    typesList = List.wrap(types)

    (typesList -- @valid_types)
    |> case do
      [_ | _] ->
        json(conn, %{"success" => false, "message" => "invalid search type"})

      _ ->
        query = "q=#{search_string}&type=#{Enum.join(typesList, ",")}"

        case HTTPoison.get!("https://api.spotify.com/v1/search?#{query}", headers()) do
          %HTTPoison.Response{status_code: 200, body: body} ->
            results =
              Jason.decode!(body)
              |> parse_search()

            json(conn, results)

          u ->
            IO.inspect(u)
        end
    end
  end

  # %{
  #   "external_urls" => %{
  #     "spotify" => "https://open.spotify.com/artist/56oDRnqbIiwx4mymNEv7dS"
  #   },
  #   "followers" => %{"href" => nil, "total" => 3095928},
  #   "genres" => ["dance pop", "escape room", "minnesota hip hop", "pop",
  #    "pop rap", "trap queen"],
  #   "href" => "https://api.spotify.com/v1/artists/56oDRnqbIiwx4mymNEv7dS",
  #   "id" => "56oDRnqbIiwx4mymNEv7dS",
  #   "images" => [
  #     %{
  #       "height" => 640,
  #       "url" => "https://i.scdn.co/image/e33e4245fe5901ed940ba95070bb8d56679b6fe0",
  #       "width" => 640
  #     },
  #     %{
  #       "height" => 320,
  #       "url" => "https://i.scdn.co/image/4f9987e4ab87fc44cb3136b7aea0ec3ad003ccd2",
  #       "width" => 320
  #     },
  #     %{
  #       "height" => 160,
  #       "url" => "https://i.scdn.co/image/a37585e2cd98ece162eba65f3c13d51a7e2d4bae",
  #       "width" => 160
  #     }
  #   ],
  #   "name" => "Lizzo",
  #   "popularity" => 80,
  #   "type" => "artist",
  #   "uri" => "spotify:artist:56oDRnqbIiwx4mymNEv7dS"
  # },

  defp parse_search(%{"artists" => item}) do
    parse_search(item["items"])
  end

  defp parse_search(%{"tracks" => item}) do
    parse_search(item["items"])
  end

  defp parse_search(%{"albums" => item}) do
    parse_search(item["items"])
  end

  defp parse_search(%{"playlists" => item}) do
    parse_search(item["items"])
  end

  defp parse_search(%{"shows" => item}) do
    parse_search(item["items"])
  end

  defp parse_search(%{"episodes" => item}) do
    parse_search(item["items"])
  end

  defp parse_search(items) do
    Enum.reduce(items, [], fn %{"id" => id, "name" => name}, acc ->
      [%{"label" => name, "value" => id} | acc]
    end)
  end

  defp headers() do
    [
      Authorization: "Bearer #{Authentication.get_token()}",
      Accept: "Application/json; Charset=utf-8"
    ]
  end

  defp build_request(params) do
    # limit
    # market
    # max_*
    # min_*
    # seed_artists
    # seed_genres
    # seed_tracks
    # target_*

    # min_acousticness float
    # min_danceability float
    # min_duration_ms  int
    # min_energy float
    # min_instrumentalness
    # min_key int E.g. 0 = C, 1 = C♯/D♭, 2 = D, and so on.
    # min_liveness
    # min_loudness
    # min_mode
    # min_popularity
    # min_speechiness
    # min_tempo
    # min_time_signature
    # min_valence

    body =
      %{
        limit: 20,
        # market: 0,
        seed_artists: "4NHQUGzhtTLFvgF5SZesLK"
        # seed_genres: ",",
        # seed_tracks: ","
        # target_acousticness: 0,
        # target_danceability: 0,
        # target_duration_ms: 0,
        # target_energy: 0,
        # target_instrumentalness: 0,
        # target_key: 0,
        # target_liveness: 0,
        # target_loudness: 0,
        # target_mode: 0,
        # target_popularity: 0,
        # target_speechiness: 0,
        # target_tempo: 0,
        # target_time_signature: 0,
        # target_valence: 0,
        # max_acousticness: 0,
        # max_danceability: 0,
        # max_duration_ms: 0,
        # max_energy: 0,
        # max_instrumentalness: 0,
        # max_key: 0,
        # max_liveness: 0,
        # max_loudness: 0,
        # max_mode: 0,
        # max_popularity: 0,
        # max_speechiness: 0,
        # max_tempo: 0,
        # max_time_signature: 0,
        # max_valence: 0,
        # min_acousticness: 0,
        # min_danceability: 0,
        # min_duration_ms: 0,
        # min_energy: 0,
        # min_instrumentalness: 0,
        # min_key: 0,
        # min_liveness: 0,
        # min_loudness: 0,
        # min_mode: 0,
        # min_popularity: 0,
        # min_speechiness: 0,
        # min_tempo: 0,
        # min_time_signature: 0,
        # min_valence: 0
      }
      |> URI.encode_query()
  end
end
