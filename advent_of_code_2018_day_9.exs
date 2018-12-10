defmodule Marble do
  def get_time() do
    DateTime.utc_now() |> DateTime.to_unix(:millisecond)
  end

  def play(players, marbles) do
    Enum.reduce(1..marbles, {%{}, %{0 => {0, 0}}, 0}, fn n, {scores, circle, current} ->
      player = rem(n, players)

      cond do
        rem(n, 23) == 0 ->
          current =
            Enum.reduce(1..7, current, fn _, current ->
              Map.get(circle, current) |> elem(0)
            end)

          {before, next} = Map.get(circle, current)

          new_circle =
            circle
            |> Map.update!(before, fn {before, _} -> {before, next} end)
            |> Map.update!(next, fn {_, next} -> {before, next} end)

          score = current + n

          new_scores = Map.update(scores, player, score, fn x -> x + score end)

          {new_scores, new_circle, next}

        true ->
          {_, next1} = Map.get(circle, current)
          {_, next2} = Map.get(circle, next1)

          new_circle =
            circle
            |> Map.update!(next1, fn _ -> {current, n} end)
            |> Map.put(n, {next1, next2})

          {scores, new_circle, n}
      end
    end)
    |> elem(0)
    |> Map.values()
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
