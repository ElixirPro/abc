defmodule OfferConsumer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      OfferConsumer.Repo,
      # Start the Telemetry supervisor
      OfferConsumerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: OfferConsumer.PubSub},
      # Start the Endpoint (http/https)
      OfferConsumerWeb.Endpoint,
      {OfferBroadway, :kafka}
      # Start a worker by calling: OfferConsumer.Worker.start_link(arg)
      # {OfferConsumer.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: OfferConsumer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    OfferConsumerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
