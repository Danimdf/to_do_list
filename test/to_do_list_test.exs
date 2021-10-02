defmodule ToDoListTest do
  use ExUnit.Case
  doctest ToDoList

  test "greets the world" do
    assert ToDoList.hello() == :world
  end
end
