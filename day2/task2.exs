defmodule M do
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
          |> M.check_list_order
      end)
    |> Enum.group_by(fn
      {:correct, _, _} -> :correct
      {:almost_asc, _, _} -> :almost_asc 
      {:almost_desc, _, _} -> :almost_desc
      _ -> :incorrect
      end)
    |> M.count_correct_lists
  end

  def is_asc_num(num) do
    num > 0 and num < 4 
  end
  def is_desc_num(num) do
    num < 0 and num > -4 
  end

  def count_correct_lists(%{correct: correct, almost_asc: almost_asc, almost_desc: almost_desc}) do
    length(correct) + M.count_almost_asc(almost_asc) + M.count_almost_desc(almost_desc)
  end

  def count_almost_asc(list) do
    list
    |>Enum.filter(fn x -> M.check_almost_asc_el(x) end)
    |> length
  end

  def check_almost_asc_el({_, _, {_, 0}}) do
    true
  end
  def check_almost_asc_el({_, _, {0, _}}) do
    true
  end
  def check_almost_asc_el({_, list, {num, idx}}) do
    cond do
      length(list) - 1 == idx -> true
      M.is_asc_num(Enum.at(list, idx + 1) + num) -> true 
      true -> false  
    end
  end

  def count_almost_desc(list) do
    list
    |>Enum.filter(fn x -> M.check_almost_desc_el(x) end)
    |> length
  end

  def check_almost_desc_el({_, _, {_, 0}}) do
    true
  end
  def check_almost_desc_el({_, _, {0, _}}) do
    true
  end
  def check_almost_desc_el({_, list, {num, idx}}) do
    cond do
      length(list) - 1 == idx -> true
      M.is_desc_num(Enum.at(list, idx + 1) + num) -> true 
      true -> false  
    end
  end

  def check_list_order(list) do
    result = 
      list
      |> Enum.with_index()
      |> Enum.group_by(fn {num, _} ->
        cond do
          M.is_asc_num(num) -> :asc  
          M.is_desc_num(num) -> :desc
          true -> :invalid
        end
      end, fn {num, index} -> {num, index} end)

    case result do
      %{asc: asc} when length(asc) == length(list) ->
        {:correct, nil, nil}
      %{desc: desc} when length(desc) == length(list) ->
        {:correct, nil, nil}
      %{asc: asc, invalid: invalid} when length(asc) == length(list) - 1 ->
        {:almost_asc, list, hd(invalid)}
      %{desc: desc, invalid: invalid} when length(desc) == length(list) - 1 ->
        {:almost_desc, list, hd(invalid)}
      %{asc: asc, desc: desc} when length(asc) >= length(list) - 1 ->
        {:almost_asc, list, hd(desc)}
      %{asc: asc, desc: desc} when length(desc) >= length(list) - 1 ->
        {:almost_desc, list, hd(asc)}
      _ ->
        {:incorrect, []}
    end
  end

end


M.f
|> IO.puts
