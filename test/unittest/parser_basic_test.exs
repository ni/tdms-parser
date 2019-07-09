defmodule Test.UnitTest.TDMSParserBasicTest do
  use ExUnit.Case

  import Test.Helper

  alias TDMS.Parser
  alias Test.TDMSWriter

  @tag unittest: true
  test "TDMS Parser parses file properties" do
    paths = [
      %{path: "file.tdms", properties: [%{name: "test", data_type: :uint32, value: 7}]}
    ]

    stream = write_file(paths)

    result = Parser.parse(stream)

    assert result == %TDMS.File{
             groups: [],
             path: "file.tdms",
             properties: [
               %TDMS.Property{data_type: :uint32, name: "test", value: 7}
             ]
           }
  end

  @tag unittest: true
  test "TDMS Parser supports big endian" do
    paths = [
      %{path: "file.tdms", properties: [%{name: "test", data_type: :uint32, value: 2048}]}
    ]

    stream = write_file(paths, endian: :big)

    result = Parser.parse(stream)

    assert result == %TDMS.File{
             groups: [],
             path: "file.tdms",
             properties: [
               %TDMS.Property{data_type: :uint32, name: "test", value: 2048}
             ]
           }
  end

  @tag unittest: true
  test "TDMS Parser parses group" do
    paths = [
      %{path: "/", properties: []},
      %{path: "/'my-group'", properties: [%{name: "data", data_type: :uint32, value: 7}]}
    ]

    stream = write_file(paths)

    result = Parser.parse(stream)

    group = find_group(result, "my-group")

    assert group == %TDMS.Group{
             channels: [],
             name: "my-group",
             path: "/'my-group'",
             properties: [
               %TDMS.Property{data_type: :string, name: "name", value: "my-group"},
               %TDMS.Property{data_type: :uint32, name: "data", value: 7}
             ]
           }
  end

  @tag unittest: true
  test "TDMS Parser parses channel" do
    paths = [
      %{path: "/", properties: []},
      %{path: "/'my-group'", properties: []},
      %{
        path: "/'my-group'/'my-channel'",
        properties: [%{name: "data", data_type: :uint32, value: 2}]
      }
    ]

    stream = write_file(paths)

    result = Parser.parse(stream)

    channel = find_channel(result, "my-group", "my-channel")

    assert channel == %TDMS.Channel{
             data: [],
             data_count: 0,
             data_type: :double,
             name: "my-channel",
             path: "/'my-group'/'my-channel'",
             properties: [
               %TDMS.Property{data_type: :string, name: "name", value: "my-channel"},
               %TDMS.Property{data_type: :string, name: "datatype", value: "DT_DOUBLE"},
               %TDMS.Property{data_type: :uint32, name: "data", value: 2}
             ]
           }
  end

  defp write_file(paths, opts \\ []) do
    <<>>
    |> TDMSWriter.write_lead_in(opts)
    |> TDMSWriter.write_paths(paths, opts)
  end
end
