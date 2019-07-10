defmodule Test.UnitTest.TDMSParserErrorTest do
  use ExUnit.Case

  alias TDMS.Parser
  alias Test.TDMSWriter

  @tag unittest: true
  test "TDMS Parser returns error if file is not a TDMS file" do
    result = Parser.parse("NO TDMS")

    assert result == {:error, "No TDMS file"}
  end

  @tag unittest: true
  test "TDMS Parser returns error if file is empty" do
    result = Parser.parse(<<>>)

    assert result == {:error, "Empty file"}
  end

  @tag unittest: true
  test "TDMS Parser returns error if there is no valid lead in" do
    result = Parser.parse("INVALID LEAD IN WITHOUT ANY USEFUL DATA")

    assert result == {:error, "No TDMS file"}
  end

  @tag unittest: true
  test "TDMS Parser returns error if TDMS version is not supported" do
    stream =
      <<>>
      |> Kernel.<>("TDSm")
      |> Kernel.<>(<<0, 0, 0, 0>>)
      |> Kernel.<>(<<10, 0, 0, 0>>)
      |> Kernel.<>(<<0, 0, 0, 0, 0, 0, 0, 0>>)
      |> Kernel.<>(<<0, 0, 0, 0, 0, 0, 0, 0>>)

    result = Parser.parse(stream)

    assert result == {:error, "Unsupported TDMS version: 10"}
  end

  @tag unittest: true
  test "TDMS Parser returns error if raw data index requires DAQmx Format Changing Scaler Parser" do
    stream =
      <<>>
      |> TDMSWriter.write_lead_in()
      |> write_single_path()
      |> Kernel.<>(<<69, 12, 00, 00>>)

    result = Parser.parse(stream)

    assert result == {:error, "DAQmx Format Changing Scaler Parser is not implemented"}
  end

  @tag unittest: true
  test "TDMS Parser returns error if raw data index requires DAQmx Digital Line Scaler Parser" do
    stream =
      <<>>
      |> TDMSWriter.write_lead_in()
      |> write_single_path()
      |> Kernel.<>(<<69, 13, 00, 00>>)

    result = Parser.parse(stream)

    assert result == {:error, "DAQmx Digital Line Scaler Parser is not implemented"}
  end

  @tag unittest: true
  test "TDMS Parser returns error if array dimensions is greater than 1" do
    stream =
      <<>>
      |> TDMSWriter.write_lead_in()
      |> write_single_path()
      |> Kernel.<>(<<20, 0, 0, 0>>)
      |> Kernel.<>(<<1, 0, 0, 0>>)
      |> Kernel.<>(<<2, 0, 0, 0>>)

    result = Parser.parse(stream)

    assert result ==
             {:error,
              "In TDMS file format version 2.0, 1 is the only valid value for array dimension"}
  end

  @tag unittest: true
  test "TDMS Parser returns error if data type is unknown" do
    stream =
      <<>>
      |> TDMSWriter.write_lead_in()
      |> write_single_path()
      |> Kernel.<>(<<20, 0, 0, 0>>)
      |> Kernel.<>(<<100, 0, 0, 0>>)

    result = Parser.parse(stream)

    assert result == {:error, "Unknown data type: 100"}
  end

  defp write_single_path(stream) do
    stream
    |> Kernel.<>(<<1, 0, 0, 0>>)
    |> Kernel.<>(<<1, 0, 0, 0, "a">>)
  end
end
