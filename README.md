# JobDemo

Code example for talk 'Elixir way by revisiting a project'

## Installation

Install the dependencies:

```
mix deps.get
```

## Git tags for demo steps

```
git checkout v01 # simple loop with pure function
git checkout v02 # Using Task, with `start`
git checkout v03 # Switch to `GenServer`
git checkout v04 # Upgrade to `DynamicSupervisor`
git checkout v05 # `GenStage` with PubSub
git checkout v06 # Using `BroadcastDispatcher`
git checkout v07 # `BroadcastDispatcher` with erlang :queue module
git checkout v08 # Update Producer `buffer_size` param

```

## Starting the app

For happy path:

```
iex -S mix
```

For error path:

```
ENABLE_ERROR=true iex -S mix
```

## Links

- [slide repo](https://github.com/gzzengwei/presentation#elixir-way-by-revisiting-a-project-on-elixir-australia)
