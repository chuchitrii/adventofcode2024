defmodule Task1 do
  def read() do
    File.stream!("input", :line)
    |> Stream.map(fn line -> 
      String.trim(line)
      |> String.split("   ") 
      |> Enum.map(fn x -> String.to_integer(x) end)
      end
    )
    |> Enum.to_list
    |> Enum.reduce({[], []}, fn [n1, n2], {list1, list2} -> {[n1|list1], [n2|list2]} end)

  end

  def f({list1, list2}) do
    Enum.zip(Enum.sort(list1), Enum.sort(list2)) 
    |> Enum.reduce(0, fn {a, b}, acc -> abs(a - b) + acc end)
  end
end

Task1.read
|> Task1.f
|> IO.puts
