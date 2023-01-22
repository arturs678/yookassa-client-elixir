defmodule DefaultYookassaClient do
  @moduledoc false

  @enforce_keys [:shop_id, :secret_key]
  defstruct([:shop_id, :secret_key])

  @type t() :: %__MODULE__{shop_id: String.t(), secret_key: String.t()}

  defimpl YookassaClient do
    @moduledoc false

    use HTTPoison.Base

    @api_endpoint "https://api.yookassa.ru/v3/"

    @impl HTTPoison.Base
    def process_url(url) do
      @api_endpoint <> url
    end

    @impl HTTPoison.Base
    def process_request_body(body) do
      Jason.encode!(body)
    end

    @impl HTTPoison.Base
    def process_request_headers(headers) do
      [{"Content-Type", "application/json"} | headers]
    end

    @impl HTTPoison.Base
    def process_response_body(body) do
      Jason.decode!(body)
    end

    @impl YookassaClient
    @spec create_payment(DefaultYookassaClient.t(), String.t(), map()) ::
            {:ok, map()} | {:error, map()}
    def create_payment(client, idempotence_key, body) do
      case response =
             post!(
               "/payments",
               body,
               [authorization_header(client), idempotence_key_header(idempotence_key)]
             ) do
        %HTTPoison.Response{status_code: 200} ->
          {:ok, response.body}

        %HTTPoison.Response{} ->
          {:error, response.body}
      end
    end

    @impl YookassaClient
    @spec capture_payment(DefaultYookassaClient.t(), String.t(), String.t(), map()) ::
            {:ok, map()} | {:error, map()}
    def capture_payment(client, idempotence_key, id, body) do
      case response =
             post!(
               "/payments/#{id}/capture",
               body,
               [authorization_header(client), idempotence_key_header(idempotence_key)]
             ) do
        %HTTPoison.Response{status_code: 200} ->
          {:ok, response.body}

        %HTTPoison.Response{} ->
          {:error, response.body}
      end
    end

    @impl YookassaClient
    @spec cancel_payment(DefaultYookassaClient.t(), String.t(), String.t()) ::
            {:ok, map()} | {:error, map()}
    def cancel_payment(client, idempotence_key, id) do
      case response =
             post!(
               "/payments/#{id}/cancel",
               %{},
               [authorization_header(client), idempotence_key_header(idempotence_key)]
             ) do
        %HTTPoison.Response{status_code: 200} ->
          {:ok, response.body}

        %HTTPoison.Response{} ->
          {:error, response.body}
      end
    end

    @impl YookassaClient
    @spec get_payment(DefaultYookassaClient.t(), String.t()) :: {:ok, map()} | {:error, map()}
    def get_payment(client, id) do
      case response = get!("/payments/#{id}", [authorization_header(client)]) do
        %HTTPoison.Response{status_code: 200} ->
          {:ok, response.body}

        %HTTPoison.Response{} ->
          {:error, response.body}
      end
    end

    defp authorization_header(client) do
      credentials =
        [client.shop_id, ":", client.secret_key]
        |> IO.iodata_to_binary()
        |> Base.encode64()

      {"Authorization", "Basic " <> credentials}
    end

    defp idempotence_key_header(idempotence_key) do
      {"Idempotence-Key", idempotence_key}
    end
  end
end
