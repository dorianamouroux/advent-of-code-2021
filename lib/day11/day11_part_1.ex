defmodule Day11.Part1 do
  def main() do
    grid = read_file()

    1..100
    |> Enum.reduce({grid, 0}, fn _, {grid, nb_flashes} ->
      {grid, current_count} = apply_step(grid, nb_flashes)
      {grid, current_count + nb_flashes}
    end)
    |> IO.inspect(charlists: :as_lists)
  end

  def apply_step(grid, _) do
    grid =
      inc_by_one(grid)
      |> apply_flashes()
      |> reset_tired_octopus()

    {grid, count_zeros(grid)}
  end

  def reset_tired_octopus(grid) do
    for y <- 0..(Enum.count(grid) - 1) do
      for x <- 0..(Enum.count(Enum.at(grid, 0)) - 1) do
        current = get_at_pos(grid, x, y)
        if current < 0, do: 0, else: current
      end
    end
  end

  def count_zeros(grid) do
    grid
    |> Enum.map(fn line -> Enum.count(line, &(&1 == 0)) end)
    |> Enum.sum()
  end

  def apply_flashes(grid) do
    next_flasher = find_next_flasher(grid)

    if next_flasher do
      {x, y} = next_flasher

      grid
      |> set_at_pos(x - 1, y - 1, &(&1 + 1))
      |> set_at_pos(x - 1, y, &(&1 + 1))
      |> set_at_pos(x - 1, y + 1, &(&1 + 1))
      |> set_at_pos(x, y - 1, &(&1 + 1))
      |> set_at_pos(x, y, fn _ -> -99999 end)
      |> set_at_pos(x, y + 1, &(&1 + 1))
      |> set_at_pos(x + 1, y - 1, &(&1 + 1))
      |> set_at_pos(x + 1, y, &(&1 + 1))
      |> set_at_pos(x + 1, y + 1, &(&1 + 1))
      |> apply_flashes()
    else
      grid
    end
  end

  def find_next_flasher(grid) do
    y = Enum.find_index(grid, fn line -> Enum.any?(line, &(&1 > 9)) end)

    if is_nil(y) do
      nil
    else
      x =
        grid
        |> Enum.at(y)
        |> Enum.find_index(&(&1 > 9))

      {x, y}
    end
  end

  def inc_by_one(grid) do
    for y <- 0..(Enum.count(grid) - 1) do
      for x <- 0..(Enum.count(Enum.at(grid, 0)) - 1) do
        get_at_pos(grid, x, y) + 1
      end
    end
  end

  def set_at_pos(grid, x, y, func) do
    if get_at_pos(grid, x, y) do
      update_in(grid, [Access.at(y), Access.at(x)], func)
    else
      grid
    end
  end

  def get_at_pos(_grid, x, _y) when x < 0, do: nil
  def get_at_pos(_grid, _x, y) when y < 0, do: nil

  def get_at_pos(grid, x, y) do
    case Enum.at(grid, y, []) do
      line -> Enum.at(line, x, nil)
    end
  end

  defp read_file() do
    [filename] = System.argv()

    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
