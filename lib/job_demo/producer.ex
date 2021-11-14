defmodule JobDemo.Producer do
  use GenStage

  alias Phoenix.PubSub

  def start_link(args) do
    GenStage.start_link(JobDemo.Producer, args, name: __MODULE__)
  end

  def init(state) do
    PubSub.subscribe(JobDemo.PubSub, "jobs")
    {:producer, state}
  end

  def handle_demand(_, state) do
    {:noreply, [], state}
  end

  def handle_info({job, data} = event, state) do
    {:noreply, [event], state}
  end
end
