defmodule ListenTooWeb.Authentication do

  def get_token() do
    headers = [
      {"Authorization", "Basic #{Application.get_env(:listen_too, :spotify_app_token)}"},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]

    request_body =
      URI.encode_query(%{
        "grant_type" => "client_credentials"
      })

    case HTTPoison.post("https://accounts.spotify.com/api/token", request_body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        %{"access_token" => token} = Jason.decode!(body)

        token

      {:ok, %HTTPoison.Response{status_code: 404, body: body}} ->
        IO.puts(body)

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end
end
