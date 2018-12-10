defmodule Marble do
  def start() do
    :ets.new(:scores, [:set, :named_table])
    :ets.new(:circle, [:set, :named_table])
  end

  def get_time() do
    DateTime.utc_now() |> DateTime.to_unix(:millisecond)
  end

  def add_score(player, score) do
    old_score =
      case :ets.lookup(:scores, player) |> Enum.at(0) do
        nil -> 0
        data -> elem(data, 1)
      end

    :ets.insert(:scores, {player, old_score + score})
  end

  def get_marble(n) do
    :ets.lookup(:circle, n) |> Enum.at(0) |> elem(1)
  end

  def play(players, marbles) do
    :ets.delete_all_objects(:scores)
    :ets.delete_all_objects(:circle)
    :ets.insert(:circle, {0, {0, 0}})

    Enum.reduce(1..marbles, {0, 0}, fn n, {current, next1} ->
      player = rem(n, players)

      cond do
        rem(n, 23) == 0 ->
          current =
            Enum.reduce(1..7, current, fn _, current ->
              get_marble(current) |> elem(0)
            end)

          {before, next} = get_marble(current)
          {before_before, _} = get_marble(before)
          {_, next_next} = get_marble(next)

          :ets.insert(:circle, [{before, {before_before, next}}, {next, {before, next_next}}])

          add_score(player, current + n)

          {next, next_next}

        true ->
          {_, next2} = get_marble(next1)

          :ets.insert(:circle, [{next1, {current, n}}, {n, {next1, next2}}])

          {n, next2}
      end
    end)

    :ets.match(:scores, :"$1")
    |> Enum.map(fn x -> x |> Enum.at(0) |> elem(1) end)
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

Marble.start()
Marble.test()
Marble.run(465, 71940)
Marble.run(465, 7_194_000)
