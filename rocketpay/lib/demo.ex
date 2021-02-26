defmodule Demo do
  def test() do
    # Task.start só lança
    t1 = Task.async(fn -> 2 + 2 end)
    t2 = Task.async(fn -> 4 + 8 end)
    Task.await_many([t1, t2])
  end

  def messaging() do
    spawn(fn ->
      IO.puts("Spawned")
      receive do
        "" -> IO.puts("Hello")
        name -> IO.puts("Hello, #{name}")
      end
      IO.puts("Ignored")
    end)
  end
end
