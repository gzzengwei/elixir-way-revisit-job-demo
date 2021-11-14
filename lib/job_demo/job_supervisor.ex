defmodule JobDemo.JobSuperviosr do
  use Supervisor, restart: :temporary

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args)
  end

  def init(args) do
    children = [
      {JobDemo.Job, args}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
