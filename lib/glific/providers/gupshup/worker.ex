defmodule Glific.Providers.Gupshup.Worker do
  use Oban.Worker,
    queue: :gupshup,
    max_attempts: 3,
    priority: 0

  alias Glific.Providers.Gupshup.ApiClient
  alias Glific.{Messages, Messages.Message}

  @rate_name Application.fetch_env!(:glific, :provider_id)
  @rate_limit Application.fetch_env!(:glific, :provider_limit)

  @impl Oban.Worker
  def perform(%{"message" => message, "payload" => payload}, _job) do
    # ensure that we are under the rate limit, all rate limits are in requests/minutes
    with {:ok, _} <- ExRated.check_rate(@rate_name, 60_000, @rate_limit) do
      ApiClient.post("/msg", payload)
      |> handle_response(message)
    else
      _ -> {:error, :rate_limit_exceeded}
    end
  end

  defp handle_response({:ok, response}, message) do
    case response do
      %Tesla.Env{status: 200} -> success_response(response, message)
      _ -> error_response(response, message)
    end
  end

  defp success_response(response, message) do
    body = response.body |> Jason.decode!()
    message
    |> Poison.encode!()
    |> Poison.decode!(as: %Message{})
    |> Messages.update_message(%{provider_message_id: body["messageId"], provider_status: :enqueued})
    {:ok, message}
  end

  defp error_response(response, _message) do
    {:error, response.body}
  end

  @impl Oban.Worker
  def backoff(attempt) do
    # We backoff exponentially but always delay by at least 60 seconds
    # this needs more work and tweaking
    trunc(:math.pow(attempt, 4) + 60 + :rand.uniform(30) * attempt)
  end
end
