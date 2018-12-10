defmodule Calculation do
  def run(s) do
    length(for a <- s, b <- s, c <- s, a < b, b < c, a + b == c, do: {a, b, c})
  end

  def test() do
    2 = run([1, 2, 3, 4])
    IO.puts("all tests passed.")
  end
end

Calculation.test()
