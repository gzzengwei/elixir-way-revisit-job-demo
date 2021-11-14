defmodule JobDemo.Job do
  use GenServer

  require Logger

  def start_link(job) do
    GenServer.start_link(__MODULE__, job, name: job)
  end

  def init(job) do
    {:ok, %{"job_type" => job, "last_done" => nil}, {:continue, :after_init}}
  end

  def handle_continue(:after_init, %{"job_type" => job} = state) do
    Logger.info("#{inspect(job)} pid #{inspect(self())}")
    {:noreply, state}
  end

  def handle_cast(:run, %{"job_type" => job} = state) do
    new_state =
      case run(job) do
        :ok ->
          %{state | "last_done" => DateTime.now!("Etc/UTC")}

        _ ->
          state
      end

    {:noreply, new_state}
  end

  def run(job) do
    enable_error(System.get_env("ENABLE_ERROR") == "true", job.error?)
    job.run
    Logger.info("#{inspect(job)} Done!")
    :ok
  end

  defp enable_error(true, true), do: raise("BOOM!!!")
  defp enable_error(_, _), do: nil
end

defmodule JobDemo.JobA do
  @job_duration 1000
  def run, do: :timer.sleep(@job_duration)
  def error?, do: false
end

defmodule JobDemo.JobB do
  @job_duration 2000
  def run, do: :timer.sleep(@job_duration)
  def error?, do: true
end

defmodule JobDemo.JobC do
  @job_duration 3000
  def run, do: :timer.sleep(@job_duration)
  def error?, do: false
end
