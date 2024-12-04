defmodule Task1 do
  def f() do
    File.stream!("input", :line)
    |> Stream.map(fn line -> 
      String.trim(line)
      |> String.split(" ") 
      |> Enum.map(fn x -> String.to_integer(x) end)
      end
    )
    |> Enum.to_list
    |> Enum.map(fn list -> 
      list 
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.map(fn [a, b] -> b - a end)
      |> then(fn list -> Enum.all?(list, &(&1 > 0 and &1 < 4)) or Enum.all?(list, &(&1 < 0 and &1 > -4))end)
    end)
    |> Enum.filter(fn x -> x end)
    |> length
  end


end


Task1.f
|> IO.puts
