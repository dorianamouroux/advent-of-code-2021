defmodule Day12.Part1 do
  def main(input) do
    paths = Day12.Part1.Parsing.parse(input)

    find_nb_paths(paths, ["start"])
    |> IO.inspect()
  end

  def find_nb_paths(_, ["end" | _]), do: 1

  def find_nb_paths(paths, [to_visit | _] = visited) do
    paths
    |> Map.get(to_visit)
    |> Enum.reject(&should_skip(&1, visited))
    |> Enum.reduce(0, fn next, total ->
      total + find_nb_paths(paths, [next | visited])
    end)
  end

  def should_skip(next, visited) do
    if next == "start" do
      true
    else
      was_visited = next in visited
      small_cave = next != String.upcase(next)
      was_visited and small_cave
    end
  end
end

defmodule Day12.Part1.Parsing do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> paths_as_map()
  end

  defp paths_as_map(paths) do
    paths
    |> Enum.map(&String.split(&1, "-"))
    |> then(fn paths ->
      reversed = Enum.map(paths, &Enum.reverse/1)
      paths ++ reversed
    end)
    |> Enum.group_by(&Enum.at(&1, 0), &Enum.at(&1, 1))
  end
end
