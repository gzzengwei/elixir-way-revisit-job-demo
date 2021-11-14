defmodule JobDemo.JobManager do
  use GenServer

  require Logger

  alias JobDemo.{JobA, JobB, JobC}
  alias JobDemo.Job

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def do_jobs() do
    GenServer.cast(__MODULE__, :do_jobs)
  end

  def init(state) do
    {:ok, state, {:continue, :after_init}}
  end

  def handle_continue(:after_init, state) do
    Logger.info("JobManager PID #{inspect(self())} ...")
    {:noreply, state}
  end

  def handle_cast(:do_jobs, state) do
    new_state =
      do_tasks
      |> Enum.reduce(state, fn result, acc -> process_job_result(result, acc) end)

    {:noreply, new_state}
  end

  defp job_list() do
    [JobA, JobB, JobC]
  end

  def do_job(job) do
    Logger.info("Starting #{inspect(job)}")
    {job, Job.run(job)}
  end

  defp do_tasks do
    job_list()
    |> Enum.map(&Task.async(fn -> do_job(&1) end))
    |> Task.await_many()
  end

  def process_job_result({job, :ok}, state) do
    Map.put(state, job, DateTime.now!("Etc/UTC"))
  end

  def process_job_result(_, state), do: state
end
