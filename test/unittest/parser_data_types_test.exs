defmodule Test.UnitTest.TDMSParserDataTypesTest do
  use ExUnit.Case

  import Test.Helper

  alias TDMS.Parser
  alias Test.TDMSWriter

  data_type_tests = [
    # unsigned integers (little endian)
    [:uint8, :little, <<1, 2>>, [1, 2]],
    [:uint16, :little, <<1, 0, 2, 0>>, [1, 2]],
    [:uint32, :little, <<1, 0, 0, 0, 2, 0, 0, 0>>, [1, 2]],
    [:uint64, :little, <<1, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0>>, [1, 2]],
    # (+) signed integers (little endian)
    [:int8, :little, <<1, 2>>, [1, 2]],
    [:int16, :little, <<1, 0, 2, 0>>, [1, 2]],
    [:int32, :little, <<1, 0, 0, 0, 2, 0, 0, 0>>, [1, 2]],
    [:int64, :little, <<1, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0>>, [1, 2]],
    # (-) signed integers (little endian)
    [:int8, :little, <<246, 236>>, [-10, -20]],
    [:int16, :little, <<246, 255, 236, 255>>, [-10, -20]],
    [:int32, :little, <<246, 255, 255, 255, 236, 255, 255, 255>>, [-10, -20]],
    [
      :int64,
      :little,
      <<246, 255, 255, 255, 255, 255, 255, 255, 236, 255, 255, 255, 255, 255, 255, 255>>,
      [-10, -20]
    ],
    # unsigned integers (big endian)
    [:uint8, :big, <<1, 2>>, [1, 2]],
    [:uint16, :big, <<0, 1, 0, 2>>, [1, 2]],
    [:uint32, :big, <<0, 0, 0, 1, 0, 0, 0, 2>>, [1, 2]],
    [:uint64, :big, <<0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 2>>, [1, 2]],
    # (+) signed integers (big endian)
    [:int8, :big, <<1, 2>>, [1, 2]],
    [:int16, :big, <<0, 1, 0, 2>>, [1, 2]],
    [:int32, :big, <<0, 0, 0, 1, 0, 0, 0, 2>>, [1, 2]],
    [:int64, :big, <<0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 2>>, [1, 2]],
    # (-) signed integers (big endian)
    [:int8, :big, <<246, 236>>, [-10, -20]],
    [:int16, :big, <<255, 246, 255, 236>>, [-10, -20]],
    [:int32, :big, <<255, 255, 255, 246, 255, 255, 255, 236>>, [-10, -20]],
    [
      :int64,
      :big,
      <<255, 255, 255, 255, 255, 255, 255, 246, 255, 255, 255, 255, 255, 255, 255, 236>>,
      [-10, -20]
    ],

    # (+) floating-point (little endian)
    [:float, :little, <<1, 2, 8, 59, 0, 1, 3, 64>>, [0.0020753147546201944, 2.04693603515625]],
    [
      :double,
      :little,
      <<0, 0, 0, 0, 0, 0, 8, 64, 1, 0, 1, 0, 0, 0, 9, 64>>,
      [3.0, 3.1250000000291043]
    ],
    # (-) floating-point (little endian)
    [
      :float,
      :little,
      <<246, 150, 211, 243, 247, 177, 211, 246>>,
      [-3.3527724875469204e31, -2.1468441269664766e33]
    ],
    [
      :double,
      :little,
      <<247, 177, 211, 246, 68, 215, 213, 191, 247, 100, 200, 236, 68, 215, 123, 191>>,
      [-0.3412640009326248, -0.0067970936184107355]
    ],
    # (+) floating-point (big endian)
    [:float, :big, <<59, 8, 2, 1, 64, 3, 1, 0>>, [0.0020753147546201944, 2.04693603515625]],
    [
      :double,
      :big,
      <<64, 8, 0, 0, 0, 0, 0, 0, 64, 9, 0, 0, 0, 1, 0, 1>>,
      [3.0, 3.1250000000291043]
    ],
    # (-) floating-point (big endian)
    [
      :float,
      :big,
      <<243, 211, 150, 246, 246, 211, 177, 247>>,
      [-3.3527724875469204e31, -2.1468441269664766e33]
    ],
    [
      :double,
      :big,
      <<191, 213, 215, 68, 246, 211, 177, 247, 191, 123, 215, 68, 236, 200, 100, 247>>,
      [-0.3412640009326248, -0.0067970936184107355]
    ],

    # boolean
    [:boolean, :little, <<1, 0>>, [true, false]],
    [:boolean, :big, <<1, 0>>, [true, false]],

    # string
    [:string, :little, <<5, 0, 0, 0, 11, 0, 0, 0>> <> "hello world", ["hello", " world"]],
    [:string, :big, <<0, 0, 0, 5, 0, 0, 0, 11>> <> "hello world", ["hello", " world"]],

    # NI timestamp
    [
      :timestamp,
      :little,
      <<0, 0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 10, 10, 10, 10, 10, 10, 10, 10, 246, 255,
        255, 255, 255, 255, 255, 255>>,
      [
        %DateTime{
          year: 1904,
          month: 1,
          day: 1,
          hour: 0,
          minute: 0,
          second: 10,
          microsecond: {0, 6},
          zone_abbr: "UTC",
          utc_offset: 0,
          std_offset: 0,
          time_zone: "Etc/UTC"
        },
        %DateTime{
          year: 1903,
          month: 12,
          day: 31,
          hour: 23,
          minute: 59,
          second: 50,
          microsecond: {39215, 6},
          zone_abbr: "UTC",
          utc_offset: 0,
          std_offset: 0,
          time_zone: "Etc/UTC"
        }
      ]
    ],
    [
      :timestamp,
      :big,
      <<0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 246,
        10, 10, 10, 10, 10, 10, 10, 10>>,
      [
        %DateTime{
          year: 1904,
          month: 1,
          day: 1,
          hour: 0,
          minute: 0,
          second: 10,
          microsecond: {0, 6},
          zone_abbr: "UTC",
          utc_offset: 0,
          std_offset: 0,
          time_zone: "Etc/UTC"
        },
        %DateTime{
          year: 1903,
          month: 12,
          day: 31,
          hour: 23,
          minute: 59,
          second: 50,
          microsecond: {39215, 6},
          zone_abbr: "UTC",
          utc_offset: 0,
          std_offset: 0,
          time_zone: "Etc/UTC"
        }
      ]
    ]
  ]

  for {[data_type, endian, data, output], index} <- Enum.with_index(data_type_tests) do
    @data_type data_type
    @endian endian
    @data data
    @output output
    @index index

    @tag unittest: true
    test "TDMS.Parser parses #{@data_type} as #{@endian} endian (#{@index})" do
      paths = [
        %{path: "/", properties: []},
        %{path: "/'my-group'", properties: []},
        %{
          path: "/'my-group'/'my-channel'",
          properties: [],
          data_type: @data_type,
          number_of_values: 2
        }
      ]

      stream = write_file(paths, @data, endian: @endian)

      result = Parser.parse(stream)

      channel = find_channel(result, "my-group", "my-channel")
      assert channel.data == @output
    end
  end

  defp write_file(paths, data, opts) do
    <<>>
    |> TDMSWriter.write_lead_in(opts)
    |> TDMSWriter.write_paths(paths, opts)
    |> TDMSWriter.write_data(data)
  end
end
