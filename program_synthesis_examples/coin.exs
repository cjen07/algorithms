defmodule Coin do
  def run(k) do
    Stream.flat_map(Stream.iterate(1, &(&1 + 1)), &(Stream.cycle([&1]) |> Enum.take(&1)))
    |> Enum.take(k)
    |> Enum.sum()
  end

  def id(n) do
    fn _ -> n end
  end

  def stream_concat(f) do
    Stream.flat_map(Stream.iterate(1, &(&1 + 1)), f)
  end

  def run1(k) do
    stream_concat(fn i -> stream_concat(id([i])) |> Enum.take(i) end)
    |> Enum.take(k)
    |> Enum.sum()
  end

  def run2(k) do
    Stream.unfold({1, 0}, fn
      {n, n} -> {n + 1, {n + 1, 1}}
      {n, m} -> {n, {n, m + 1}}
    end)
    |> Enum.take(k)
    |> Enum.sum()
  end

  def test() do
    14 = run(6)
    29820 = run(1000)
    14 = run1(6)
    29820 = run1(1000)
    14 = run2(6)
    29820 = run2(1000)
    IO.puts("all tests passed.")
  end
end

Coin.test()
