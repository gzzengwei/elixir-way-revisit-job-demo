defmodule JobDemo.JobManager do
  use GenServer

  require Logger

  alias JobDemo.{JobA, JobB, JobC}
  alias JobDemo.{Job, JobRunner, JobSuperviosr}

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

    new_state =
      job_list()
      |> Enum.map(&start_job_supervisor(&1))
      |> Enum.reduce(state, fn {job, pid}, acc -> Map.put(acc, job, pid) end)

    {:noreply, new_state}
  end

  def handle_cast(:do_jobs, state) do
    new_state =
      job_list()
      |> Enum.map(&do_job(&1))

    {:noreply, new_state}
  end

  defp job_list() do
    [JobA, JobB, JobC]
  end

  defp do_job(job) do
    Logger.info("Starting #{inspect(job)} ...")
    GenServer.cast(job, :run)
  end

  defp start_job_supervisor(job) do
    Logger.info("Starting Supervisor for #{inspect(job)}")

    case DynamicSupervisor.start_child(JobRunner, {JobSuperviosr, job}) do
      {:ok, supvervisor_pid} ->
        {job, supvervisor_pid}

      _ ->
        {job, nil}
    end
  end
end
