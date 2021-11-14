defmodule JobDemoTest do
  use ExUnit.Case
  doctest JobDemo

  test "greets the world" do
    assert JobDemo.hello() == :world
  end
end
