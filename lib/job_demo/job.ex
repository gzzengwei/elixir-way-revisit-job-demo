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

  @chunk_size 2
  def run(job) do
    enable_error(System.get_env("ENABLE_ERROR") == "true", job.error?())

    job.range()
    |> Stream.map(fn _ -> job.data() end)
    |> Stream.chunk_every(@chunk_size)
    |> Enum.each(&broadcast_rows(&1, job))

    Logger.info("#{inspect(job)} broadcast!")
    :ok
  end

  defp broadcast_rows(chuck_data, job) do
    Phoenix.PubSub.broadcast(
      JobDemo.PubSub,
      "jobs",
      {inspect(job), chuck_data}
    )
  end

  defp enable_error(true, true), do: raise("BOOM!!!")
  defp enable_error(_, _), do: nil
end

defmodule JobDemo.JobA do
  def range, do: 1..10
  def data, do: ["1", "2", "3"]
  def error?, do: false
end

defmodule JobDemo.JobB do
  def range, do: 1..20
  def data, do: ["4", "5", "6"]
  def error?, do: true
end

defmodule JobDemo.JobC do
  def range, do: 1..30
  def data, do: ["7", "8", "9"]
  def error?, do: false
end
