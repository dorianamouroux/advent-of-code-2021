defmodule Day2.Part1 do
  def main(input) do
    steps = read_file(input)
    {position, depth} = run_steps(steps, 0, 0)

    IO.inspect("position = #{position}")
    IO.inspect("depth = #{depth}")
    IO.inspect("horizon position = #{depth * position}")
  end

  def run_steps([], position, depth) do
    {position, depth}
  end

  def run_steps([current_step | next_steps], position, depth) do
    {position, depth} =
      case current_step do
        {"forward", size} -> {position + size, depth}
        {"up", size} -> {position, depth - size}
        {"down", size} -> {position, depth + size}
      end

    run_steps(next_steps, position, depth)
  end

  defp read_file(input) do
    input
    |> String.split("\n")
    |> Enum.filter(fn line -> line != "" end)
    |> Enum.map(fn line ->
      [action, size] = String.split(line, " ")
      {size, _} = Integer.parse(size)
      {action, size}
    end)
  end
end
