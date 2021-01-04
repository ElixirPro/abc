defmodule OfferConsumer.Repo do
  use Ecto.Repo,
    otp_app: :offer_consumer,
    adapter: Ecto.Adapters.Postgres
end
