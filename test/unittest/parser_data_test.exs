defmodule Test.UnitTest.TDMSParserDataTest do
  use ExUnit.Case

  import Test.Helper

  alias TDMS.Parser
  alias Test.TDMSWriter

  @tag unittest: true
  test "TDMS.Parser parses single unsigned value as little endian" do
    paths = [
      %{path: "/", properties: []},
      %{path: "/'my-group'", properties: []},
      %{path: "/'my-group'/'my-channel'", properties: [], data_type: :uint32, number_of_values: 1}
    ]

    stream = write_file(paths, <<10, 00, 00, 00>>)

    result = Parser.parse(stream)

    channel = find_channel(result, "my-group", "my-channel")
    assert channel.data == [10]
  end

  @tag unittest: true
  test "TDMS.Parser parses single unsigned value as big endian" do
    paths = [
      %{path: "/", properties: []},
      %{path: "/'my-group'", properties: []},
      %{path: "/'my-group'/'my-channel'", properties: [], data_type: :uint32, number_of_values: 1}
    ]

    stream = write_file(paths, <<00, 00, 00, 10>>, endian: :big)

    result = Parser.parse(stream)

    channel = find_channel(result, "my-group", "my-channel")
    assert channel.data == [10]
  end

  @tag unittest: true
  test "TDMS.Parser parses single signed value as little endian" do
    paths = [
      %{path: "/", properties: []},
      %{path: "/'my-group'", properties: []},
      %{path: "/'my-group'/'my-channel'", properties: [], data_type: :int32, number_of_values: 1}
    ]

    stream = write_file(paths, <<246, 255, 255, 255>>)

    result = Parser.parse(stream)

    channel = find_channel(result, "my-group", "my-channel")
    assert channel.data == [-10]
  end

  @tag unittest: true
  test "TDMS.Parser parses single signed value as big endian" do
    paths = [
      %{path: "/", properties: []},
      %{path: "/'my-group'", properties: []},
      %{path: "/'my-group'/'my-channel'", properties: [], data_type: :int32, number_of_values: 1}
    ]

    stream = write_file(paths, <<255, 255, 255, 246>>, endian: :big)

    result = Parser.parse(stream)

    channel = find_channel(result, "my-group", "my-channel")
    assert channel.data == [-10]
  end

  @tag unittest: true
  test "TDMS.Parser parses multiple values" do
    paths = [
      %{path: "/", properties: []},
      %{path: "/'my-group'", properties: []},
      %{path: "/'my-group'/'my-channel'", properties: [], data_type: :uint32, number_of_values: 3}
    ]

    stream = write_file(paths, <<00, 00, 00, 01, 00, 00, 00, 02, 00, 00, 00, 03>>, endian: :big)

    result = Parser.parse(stream)

    channel = find_channel(result, "my-group", "my-channel")
    assert channel.data == [1, 2, 3]
  end

  @tag unittest: true
  test "TDMS.Parser parses multiple channels" do
    paths = [
      %{path: "/", properties: []},
      %{path: "/'my-group'", properties: []},
      %{
        path: "/'my-group'/'my-channel-1'",
        properties: [],
        data_type: :int16,
        number_of_values: 3
      },
      %{path: "/'my-group'/'my-channel-2'", properties: [], data_type: :int8, number_of_values: 3}
    ]

    stream = write_file(paths, <<01, 00, 02, 00, 03, 00, 10, 20, 30>>)

    result = Parser.parse(stream)

    channel1 = find_channel(result, "my-group", "my-channel-1")
    assert channel1.data == [1, 2, 3]
    channel2 = find_channel(result, "my-group", "my-channel-2")
    assert channel2.data == [10, 20, 30]
  end

  @tag unittest: true
  test "TDMS.Parser parses multiple channels (interleaved)" do
    paths = [
      %{path: "/", properties: []},
      %{path: "/'my-group'", properties: []},
      %{
        path: "/'my-group'/'my-channel-1'",
        properties: [],
        data_type: :int16,
        number_of_values: 3
      },
      %{path: "/'my-group'/'my-channel-2'", properties: [], data_type: :int8, number_of_values: 3}
    ]

    stream = write_file(paths, <<01, 00, 10, 02, 00, 20, 03, 00, 30>>, interleaved: true)

    result = Parser.parse(stream)

    channel1 = find_channel(result, "my-group", "my-channel-1")
    assert channel1.data == [1, 2, 3]
    channel2 = find_channel(result, "my-group", "my-channel-2")
    assert channel2.data == [10, 20, 30]
  end

  @tag unittest: true
  test "TDMS.Parser parses multiple channels (interleaved) with different number of values" do
    paths = [
      %{path: "/", properties: []},
      %{path: "/'my-group'", properties: []},
      %{
        path: "/'my-group'/'my-channel-1'",
        properties: [],
        data_type: :uint8,
        number_of_values: 3
      },
      %{
        path: "/'my-group'/'my-channel-2'",
        properties: [],
        data_type: :uint8,
        number_of_values: 1
      },
      %{
        path: "/'my-group'/'my-channel-3'",
        properties: [],
        data_type: :uint8,
        number_of_values: 2
      }
    ]

    stream = write_file(paths, <<01, 10, 100, 02, 200, 03>>, interleaved: true)

    result = Parser.parse(stream)

    channel1 = find_channel(result, "my-group", "my-channel-1")
    assert channel1.data == [1, 2, 3]
    channel2 = find_channel(result, "my-group", "my-channel-2")
    assert channel2.data == [10]
    channel3 = find_channel(result, "my-group", "my-channel-3")
    assert channel3.data == [100, 200]
  end

  defp write_file(paths, data, opts \\ []) do
    <<>>
    |> TDMSWriter.write_lead_in(opts)
    |> TDMSWriter.write_paths(paths, opts)
    |> TDMSWriter.write_data(data)
  end
end
