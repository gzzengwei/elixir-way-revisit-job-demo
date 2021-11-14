defmodule JobDemo.JobManager do
  require Logger

  alias JobDemo.{JobA, JobB, JobC}
  alias JobDemo.Job

  def do_jobs do
    job_list()
    |> Enum.each(&do_job(&1))
  end

  defp job_list() do
    [JobA, JobB, JobC]
  end

  def do_job(job) do
    Logger.info("Starting #{inspect(job)}")
    job |> Job.run()
  end
end
