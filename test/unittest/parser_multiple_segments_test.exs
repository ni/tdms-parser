defmodule Test.UnitTest.TDMSParserMultipleSegmentsTest do
  use ExUnit.Case

  import Test.Helper

  alias TDMS.Parser
  alias Test.TDMSWriter

  @tag unittest: true
  test "TDMS.Parser parses multiple segments with lead ins and data" do
    paths = [
      %{path: "/", properties: []},
      %{path: "/'my-group'", properties: []},
      %{path: "/'my-group'/'my-channel'", properties: [], data_type: :uint32, number_of_values: 1}
    ]

    stream =
      <<>>
      |> TDMSWriter.write_lead_in()
      |> TDMSWriter.write_paths(paths)
      |> TDMSWriter.write_data(<<10, 00, 00, 00>>)
      |> TDMSWriter.write_lead_in()
      |> TDMSWriter.write_paths(paths)
      |> TDMSWriter.write_data(<<20, 00, 00, 00>>)

    result = Parser.parse(stream)

    channel = find_channel(result, "my-group", "my-channel")
    assert channel.data == [10, 20]
  end

  @tag unittest: true
  test "TDMS.Parser parses multiple segments with lead ins but without data" do
    paths = [
      %{path: "/", properties: []},
      %{path: "/'my-group'", properties: []},
      %{path: "/'my-group'/'my-channel'", properties: [], data_type: :uint32, number_of_values: 0}
    ]

    stream =
      <<>>
      |> TDMSWriter.write_lead_in()
      |> TDMSWriter.write_paths(paths)
      |> TDMSWriter.write_lead_in()
      |> TDMSWriter.write_paths(paths)

    result = Parser.parse(stream)

    assert length(result.groups) == 1
    group = List.first(result.groups)
    assert group.name == "my-group"

    assert length(group.channels) == 1
    channel = List.first(group.channels)
    assert channel.name == "my-channel"
  end

  @tag unittest: true
  test "TDMS.Parser parses single segment with additional data blocks" do
    paths = [
      %{path: "/", properties: []},
      %{path: "/'my-group'", properties: []},
      %{path: "/'my-group'/'my-channel'", properties: [], data_type: :uint32, number_of_values: 1}
    ]

    stream =
      <<>>
      |> TDMSWriter.write_lead_in()
      |> TDMSWriter.write_paths(paths)
      |> TDMSWriter.write_data(<<10, 00, 00, 00, 20, 00, 00, 00, 30, 00, 00, 00>>)

    result = Parser.parse(stream)

    channel = find_channel(result, "my-group", "my-channel")
    assert channel.data == [10, 20, 30]
  end

  @tag unittest: true
  test "TDMS.Parser parses multiple segments which refer to previous metadata" do
    paths = [
      %{path: "/", properties: []},
      %{path: "/'my-group'", properties: []},
      %{path: "/'my-group'/'my-channel'", properties: [], data_type: :uint32, number_of_values: 0}
    ]

    stream =
      <<>>
      |> TDMSWriter.write_lead_in()
      |> TDMSWriter.write_paths(paths)
      |> TDMSWriter.write_lead_in()
      |> TDMSWriter.write_previous_raw_data_index(["/", "/'my-group'", "/'my-group'/'my-channel'"])

    result = Parser.parse(stream)

    assert length(result.groups) == 1
    group = List.first(result.groups)
    assert group.name == "my-group"

    assert length(group.channels) == 1
    channel = List.first(group.channels)
    assert channel.name == "my-channel"
  end

  @tag unittest: true
  test "TDMS.Parser parses multiple segments with data which refer to previous metadata" do
    paths = [
      %{path: "/", properties: []},
      %{path: "/'my-group'", properties: []},
      %{path: "/'my-group'/'my-channel'", properties: [], data_type: :uint32, number_of_values: 2}
    ]

    stream =
      <<>>
      |> TDMSWriter.write_lead_in()
      |> TDMSWriter.write_paths(paths)
      |> TDMSWriter.write_data(<<10, 00, 00, 00, 20, 00, 00, 00>>)
      |> TDMSWriter.write_lead_in()
      |> TDMSWriter.write_previous_raw_data_index(["/'my-group'/'my-channel'"])
      |> TDMSWriter.write_data(<<30, 00, 00, 00, 40, 00, 00, 00>>)

    result = Parser.parse(stream)

    channel = find_channel(result, "my-group", "my-channel")
    assert channel.data == [10, 20, 30, 40]
  end
end
