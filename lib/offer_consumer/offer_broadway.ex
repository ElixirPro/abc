defmodule OfferBroadway do
  use Broadway

  alias Broadway.Message
  alias OfferConsumer.Products

  def start_link(name) do
    Broadway.start_link(__MODULE__,
      name: name,
      producer: [
        module: {
          BroadwayKafka.Producer,
          [
            hosts: [localhost: 9092],
            group_id: "offer_consumer",
            topics: ["offers"]
          ]
        },
        concurrency: 10
      ],
      processors: [
        default: [
          concurrency: 2
        ]
      ],
      batchers: [
        big_discount: [concurrency: 2, batch_size: 10],
        discount: [concurrency: 1, batch_size: 10]
      ]
    )
  end

  def handle_message(_processor, %Message{data: data} = message, _context) do
    payload =
      data
      |> Jason.decode!()
      |> IO.inspect()

    message = Message.update_data(message, &(&1 |> Jason.decode!()))

    if payload["discount"] >= 50 do
      Message.put_batcher(message, :big_discount)
    else
      Message.put_batcher(message, :discount)
    end
  end

  def handle_batch(:big_discount, messages, _batch_info, _context) do
    Enum.map(messages, &(&1.data |> Products.create_product))
    messages
  end

  def handle_batch(:discount, messages, _batch_info, _context) do
    Enum.map(messages, &(&1.data |> Products.create_product))
    messages
  end
end
