defmodule Test.IntegrationTest.TDMSParserTest do
  use ExUnit.Case

  import Test.Helper

  alias TDMS.Parser

  @tag integrationtest: true
  test "TDMS Parser parses basic TDMS file" do
    result = Parser.parse(File.read!("test/data/basic.tdms"))

    assert result ==
             %TDMS.File{
               path: "/",
               properties: [
                 %TDMS.Property{
                   data_type: :string,
                   name: "name",
                   value: "InMemoryFile_lvt-1229270998_0471"
                 }
               ],
               groups: [
                 %TDMS.Group{
                   name: "b-ni-crio-9064-030dbfed",
                   path: "/'b-ni-crio-9064-030dbfed'",
                   properties: [
                     %TDMS.Property{
                       data_type: :string,
                       name: "name",
                       value: "b-ni-crio-9064-030dbfed"
                     }
                   ],
                   channels: [
                     %TDMS.Channel{
                       data: [
                         22.818841586201092,
                         22.762844518038662,
                         22.81235724493523,
                         22.813042769326525,
                         22.78541260540583,
                         22.632549049618422
                       ],
                       data_count: 6,
                       data_type: :double,
                       name: "ai.0",
                       path: "/'b-ni-crio-9064-030dbfed'/'ai.0'",
                       properties: [
                         %TDMS.Property{data_type: :string, name: "name", value: "ai.0"},
                         %TDMS.Property{
                           data_type: :string,
                           name: "datatype",
                           value: "DT_DOUBLE"
                         },
                         %TDMS.Property{
                           data_type: :timestamp,
                           name: "wf_start_time",
                           value: %DateTime{
                             year: 1904,
                             month: 01,
                             day: 01,
                             hour: 00,
                             minute: 00,
                             second: 00,
                             microsecond: {0, 6},
                             zone_abbr: "UTC",
                             utc_offset: 0,
                             std_offset: 0,
                             time_zone: "Etc/UTC"
                           }
                         },
                         %TDMS.Property{
                           data_type: :double,
                           name: "wf_start_offset",
                           value: 0.0
                         },
                         %TDMS.Property{data_type: :double, name: "wf_increment", value: 1.0},
                         %TDMS.Property{data_type: :int32, name: "wf_samples", value: 6},
                         %TDMS.Property{
                           data_type: :string,
                           name: "NI_ChannelName",
                           value: "ai.0"
                         },
                         %TDMS.Property{
                           data_type: :string,
                           name: "NI_UnitDescription",
                           value: "Degrees Celsius"
                         },
                         %TDMS.Property{
                           data_type: :string,
                           name: "unit_string",
                           value: "Degrees Celsius"
                         }
                       ]
                     },
                     %TDMS.Channel{
                       data: [
                         23.44229550734343,
                         23.525080853361512,
                         23.620682016490747,
                         23.414727116690415,
                         23.335813573887656,
                         23.16530703212129
                       ],
                       data_count: 6,
                       data_type: :double,
                       name: "ai.1",
                       path: "/'b-ni-crio-9064-030dbfed'/'ai.1'",
                       properties: [
                         %TDMS.Property{data_type: :string, name: "name", value: "ai.1"},
                         %TDMS.Property{
                           data_type: :string,
                           name: "datatype",
                           value: "DT_DOUBLE"
                         },
                         %TDMS.Property{
                           data_type: :timestamp,
                           name: "wf_start_time",
                           value: %DateTime{
                             year: 1904,
                             month: 01,
                             day: 01,
                             hour: 00,
                             minute: 00,
                             second: 00,
                             microsecond: {0, 6},
                             zone_abbr: "UTC",
                             utc_offset: 0,
                             std_offset: 0,
                             time_zone: "Etc/UTC"
                           }
                         },
                         %TDMS.Property{
                           data_type: :double,
                           name: "wf_start_offset",
                           value: 0.0
                         },
                         %TDMS.Property{data_type: :double, name: "wf_increment", value: 1.0},
                         %TDMS.Property{data_type: :int32, name: "wf_samples", value: 6},
                         %TDMS.Property{
                           data_type: :string,
                           name: "NI_ChannelName",
                           value: "ai.1"
                         },
                         %TDMS.Property{
                           data_type: :string,
                           name: "NI_UnitDescription",
                           value: "Degrees Celsius"
                         },
                         %TDMS.Property{
                           data_type: :string,
                           name: "unit_string",
                           value: "Degrees Celsius"
                         }
                       ]
                     },
                     %TDMS.Channel{
                       data: [
                         22.989411954913283,
                         22.94856004160348,
                         23.0220603802152,
                         22.992474153745942,
                         22.936790340283352,
                         22.837116467091995
                       ],
                       data_count: 6,
                       data_type: :double,
                       name: "ai.2",
                       path: "/'b-ni-crio-9064-030dbfed'/'ai.2'",
                       properties: [
                         %TDMS.Property{data_type: :string, name: "name", value: "ai.2"},
                         %TDMS.Property{
                           data_type: :string,
                           name: "datatype",
                           value: "DT_DOUBLE"
                         },
                         %TDMS.Property{
                           data_type: :timestamp,
                           name: "wf_start_time",
                           value: %DateTime{
                             year: 1904,
                             month: 01,
                             day: 01,
                             hour: 00,
                             minute: 00,
                             second: 00,
                             microsecond: {0, 6},
                             zone_abbr: "UTC",
                             utc_offset: 0,
                             std_offset: 0,
                             time_zone: "Etc/UTC"
                           }
                         },
                         %TDMS.Property{
                           data_type: :double,
                           name: "wf_start_offset",
                           value: 0.0
                         },
                         %TDMS.Property{data_type: :double, name: "wf_increment", value: 1.0},
                         %TDMS.Property{data_type: :int32, name: "wf_samples", value: 6},
                         %TDMS.Property{
                           data_type: :string,
                           name: "NI_ChannelName",
                           value: "ai.2"
                         },
                         %TDMS.Property{
                           data_type: :string,
                           name: "NI_UnitDescription",
                           value: "Degrees Celsius"
                         },
                         %TDMS.Property{
                           data_type: :string,
                           name: "unit_string",
                           value: "Degrees Celsius"
                         }
                       ]
                     },
                     %TDMS.Channel{
                       data: [
                         23.02152947007314,
                         22.981786241161018,
                         23.063959426284104,
                         23.034928031556944,
                         23.017455316912063,
                         22.922772683628892
                       ],
                       data_count: 6,
                       data_type: :double,
                       name: "ai.3",
                       path: "/'b-ni-crio-9064-030dbfed'/'ai.3'",
                       properties: [
                         %TDMS.Property{data_type: :string, name: "name", value: "ai.3"},
                         %TDMS.Property{
                           data_type: :string,
                           name: "datatype",
                           value: "DT_DOUBLE"
                         },
                         %TDMS.Property{
                           data_type: :timestamp,
                           name: "wf_start_time",
                           value: %DateTime{
                             year: 1904,
                             month: 01,
                             day: 01,
                             hour: 00,
                             minute: 00,
                             second: 00,
                             microsecond: {0, 6},
                             zone_abbr: "UTC",
                             utc_offset: 0,
                             std_offset: 0,
                             time_zone: "Etc/UTC"
                           }
                         },
                         %TDMS.Property{
                           data_type: :double,
                           name: "wf_start_offset",
                           value: 0.0
                         },
                         %TDMS.Property{data_type: :double, name: "wf_increment", value: 1.0},
                         %TDMS.Property{data_type: :int32, name: "wf_samples", value: 6},
                         %TDMS.Property{
                           data_type: :string,
                           name: "NI_ChannelName",
                           value: "ai.3"
                         },
                         %TDMS.Property{
                           data_type: :string,
                           name: "NI_UnitDescription",
                           value: "Degrees Celsius"
                         },
                         %TDMS.Property{
                           data_type: :string,
                           name: "unit_string",
                           value: "Degrees Celsius"
                         }
                       ]
                     }
                   ]
                 }
               ]
             }
  end

  @tag integrationtest: true
  test "TDMS Parser parses TDMS file with multiple groups" do
    result = Parser.parse(File.read!("test/data/multiple_groups.tdms"))

    assert length(result.groups) == 2
    group1 = Enum.at(result.groups, 0)
    group2 = Enum.at(result.groups, 1)
    assert group1.name == "Noise Tolerance"
    assert group2.name == "Channel Output"

    assert get_channel_names(group1) == ["Measurement", "High Limit", "Low Limit"]

    assert get_channel_names(group2) == [
             "Measurement",
             "Channel Number",
             "High Limit",
             "Low Limit"
           ]
  end

  @tag integrationtest: true
  test "TDMS Parser parses TDMS file version 1" do
    result = Parser.parse(File.read!("test/data/version1.tdms"))

    assert length(result.groups) == 1
    group = Enum.at(result.groups, 0)
    assert length(group.channels) == 7
  end

  @tag integrationtest: true
  test "TDMS Parser parses TDMS file with strings" do
    result = Parser.parse(File.read!("test/data/strings.tdms"))

    channel = find_channel(result, "test1", "DUT Preamp")

    assert channel.data_count == 234
    assert channel.data_type == :string
    assert List.first(channel.data) == "off"
    assert List.last(channel.data) == "on"
  end

  defp get_channel_names(group) do
    Enum.map(group.channels, fn c -> c.name end)
  end
end
