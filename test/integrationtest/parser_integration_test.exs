defmodule Test.IntegrationTest.TDMSParserTest do
  use ExUnit.Case

  alias TDMS.Parser

  @tag integrationtest: true
  test "TDMS Parser parses files without error" do
    files = Path.wildcard("test/data/*.tdms")
    do_parse(files)
  end

  defp do_parse([]) do
    :ok
  end

  defp do_parse([file | files]) do
    IO.inspect("Parsing file: #{file}")
    result = Parser.parse(File.read!(file))

    assert result.path == "/"

    do_parse(files)
  end
end
