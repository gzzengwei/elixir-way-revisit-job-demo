defmodule JobDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # {JobDemo.Scheduler, []},
      # {Phoenix.PubSub, name: JobDemo.PubSub},
      {JobDemo.JobManager, %{}},
      {DynamicSupervisor, dynamic_supervisor_config()},
      {JobDemo.Producer, []},
      {JobDemo.Consumer, []}
      # %{
      #   id: "Consumer_1",
      #   start: {JobDemo.Consumer, :start_link, [[]]}
      # },
      # %{
      #   id: "Consumer_2",
      #   start: {JobDemo.Consumer, :start_link, [[]]}
      # }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: JobDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp dynamic_supervisor_config do
    [
      strategy: :one_for_one,
      name: JobDemo.JobRunner
    ]
  end
end
