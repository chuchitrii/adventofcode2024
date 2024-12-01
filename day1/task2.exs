defmodule Task2 do
  def count_occurences([n1, n2], {map1, map2}) do
    {Map.put(map1, n1, Map.get(map1, n1, 0) + 1), Map.put(map2, n2, Map.get(map2, n2, 0) + 1)}
  end

  def get_result({map1, map2}) do
    Enum.reduce(map1, 0, fn {k, v}, acc -> k * v * Map.get(map2, k, 0) + acc end)
  end

  def f() do
    File.stream!("input", :line)
    |> Stream.map(fn line -> 
      String.trim(line)
      |>String.split("   ") 
      |> Enum.map(fn x -> String.to_integer(x) end)
      end
    )
    |> Enum.to_list
    |> Enum.reduce({%{}, %{}}, fn lists, maps -> Task2.count_occurences(lists, maps) end)
    |> get_result
  end
end

Task2.f
|> IO.puts
