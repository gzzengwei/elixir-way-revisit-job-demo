defmodule JobDemo.Consumer do
  use GenStage
  require Logger

  def start_link(_opts) do
    GenStage.start_link(JobDemo.Consumer, [])
  end

  def init(state) do
    {:consumer, state, subscribe_to: [JobDemo.Producer]}
  end

  def handle_events(events, _from, state) do
    # doing actual work
    Process.sleep(50)
    Logger.info("Consumer #{inspect(self())} processing: #{inspect(events)}")
    {:noreply, [], state}
  end
end
