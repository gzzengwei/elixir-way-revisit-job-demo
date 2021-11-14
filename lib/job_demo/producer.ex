defmodule JobDemo.Producer do
  use GenStage

  def start_link(args) do
    GenStage.start_link(JobDemo.Producer, args, name: __MODULE__)
  end

  def sync_notify(event, timeout \\ 5000) do
    GenStage.call(__MODULE__, {:notify, event}, timeout)
  end

  def init(state) do
    {:producer, state, dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_demand(_, state) do
    {:noreply, [], state}
  end

  def handle_call({:notify, event}, _from, state) do
    # Dispatch immediately
    {:reply, :ok, [event], state}
  end
end
