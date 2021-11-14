defmodule JobDemo.Job do
  require Logger

  def run(job) do
    enable_error(System.get_env("ENABLE_ERROR") == "true", job.error?)
    job.run
    Logger.info("#{inspect(job)} Done!")
    :ok
  # rescue
  #   err in RuntimeError ->
  #     Logger.error(inspect(err))
  #     :err
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
