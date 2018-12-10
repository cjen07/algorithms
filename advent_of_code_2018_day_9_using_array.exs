defmodule Marble do
  def get_time() do
    DateTime.utc_now() |> DateTime.to_unix(:millisecond)
  end

  def play(players, marbles) do
    scores = :array.new([{:size, players}, {:fixed, true}, {:default, 0}])
    circle = :array.new([{:size, marbles + 1}, {:fixed, true}, {:default, {0, 0}}])

    Enum.reduce(1..marbles, {scores, circle, 0}, fn n, {scores, circle, current} ->
      player = rem(n, players)

      cond do
        rem(n, 23) == 0 ->
          current =
            Enum.reduce(1..7, current, fn _, current ->
              :array.get(current, circle) |> elem(0)
            end)

          {before, next} = :array.get(current, circle)
          {before_before, _} = :array.get(before, circle)
          {_, next_next} = :array.get(next, circle)

          circle = :array.set(before, {before_before, next}, circle)
          circle = :array.set(next, {before, next_next}, circle)

          score = :array.get(player, scores)
          scores = :array.set(player, score + current + n, scores)

          {scores, circle, next}

        true ->
          {_, next1} = :array.get(current, circle)
          {_, next2} = :array.get(next1, circle)

          circle = :array.set(next1, {current, n}, circle)
          circle = :array.set(n, {next1, next2}, circle)

          {scores, circle, n}
      end
    end)
    |> elem(0)
    |> :array.to_list()
    |> Enum.max()
  end

  def run(players, marbles) do
    t1 = get_time()
    play(players, marbles) |> IO.inspect()
    t2 = get_time()
    IO.inspect((t2 - t1) / 1000.0)
    :ok
  end

  def test() do
    32 = play(9, 25)
    8317 = play(10, 1618)
    146_373 = play(13, 7999)
    2764 = play(17, 1104)
    54718 = play(21, 6111)
    37305 = play(30, 5807)
    IO.puts("all tests passed.")
  end
end

Marble.test()
Marble.run(465, 71940)
Marble.run(465, 7_194_000)
