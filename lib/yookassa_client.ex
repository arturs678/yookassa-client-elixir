defprotocol YookassaClient do
  @moduledoc false

  @spec create_payment(t(), String.t(), map()) ::
          {:ok, map()} | {:error, {:http_error, HTTPoison.Error.t()} | {:yokassa_error, map()}}
  def create_payment(client, idempotence_key, body)

  @spec capture_payment(t(), String.t(), String.t(), map()) ::
          {:ok, map()} | {:error, {:http_error, HTTPoison.Error.t()} | {:yokassa_error, map()}}
  def capture_payment(client, idempotence_key, id, body)

  @spec cancel_payment(t(), String.t(), String.t()) ::
          {:ok, map()} | {:error, {:http_error, HTTPoison.Error.t()} | {:yokassa_error, map()}}
  def cancel_payment(client, idempotence_key, id)

  @spec get_payment(t(), String.t()) ::
          {:ok, map()} | {:error, {:http_error, HTTPoison.Error.t()} | {:yokassa_error, map()}}
  def get_payment(client, id)
end
