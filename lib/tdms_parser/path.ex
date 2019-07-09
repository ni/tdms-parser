defmodule TDMS.Parser.Path do
  @moduledoc false
  # Interal functions for parsing TDMS paths.
  #
  # Every TDMS object is uniquely identified by a path. Each path is a string including the name
  # of the object and the name of its owner in the TDMS hierarchy, separated by a forward slash.
  # Each name is enclosed by the quotation marks. Any single quotation mark within an object name
  # is replaced with double quotation marks.
  #
  # The following table illustrates path formatting examples for each type of TDMS object:
  #
  #   | Object Name     | Object  | Path                               |
  #   | --------------- | ------- | ---------------------------------- |
  #   | --              | File    | /                                  |
  #   | Measured Data   | Group   | /'Measured Data'                   |
  #   | Amplitude Sweep | Channel | /'Measured Data'/'Amplitude Sweep' |
  #   | Events          | Group   | /'Events'                          |
  #   | Time            | Channel | /'Events'/'Time'                   |

  def get_name(path) do
    split_path(path)
    |> List.last()
  end

  defp split_path(path) do
    split_path(path, false, "", [])
  end

  defp split_path("", _is_escaped, current, results) do
    results =
      case current do
        "" -> results
        current -> [current | results]
      end

    Enum.reverse(results)
  end

  defp split_path(<<"'", tail::binary>>, is_escaped, current, result) do
    split_path(tail, not is_escaped, current, result)
  end

  defp split_path(<<"/", tail::binary>>, false, current, result) do
    split_path(tail, false, "", [current | result])
  end

  defp split_path(<<"/", tail::binary>>, true, current, result) do
    split_path(tail, true, current <> "/", result)
  end

  defp split_path(<<c::utf8, tail::binary>>, is_escaped, current, result) do
    split_path(tail, is_escaped, current <> <<c::utf8>>, result)
  end

  def depth(path) do
    split_path(path)
    |> length()
  end

  def is_child(child_path, path) do
    String.starts_with?(child_path, path <> "/")
  end
end
