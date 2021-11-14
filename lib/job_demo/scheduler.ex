defmodule JobDemo.Scheduler do
  use GenServer

  @schedule_interval 7_000

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    {:ok, %{}, {:continue, :after_init}}
  end

  def handle_continue(:after_init, state) do
    Process.whereis(__MODULE__)
    |> IO.inspect(label: "Scheduler started, pid")

    Process.send_after(self(), :do_jobs, @schedule_interval)
    {:noreply, state}
  end

  def handle_info(:do_jobs, state) do
    Process.send_after(self(), :do_jobs, @schedule_interval)
    JobDemo.JobManager.do_jobs()
    {:noreply, state}
  end
end
