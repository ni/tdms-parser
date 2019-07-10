defmodule TDMS.Parser.ValueParser do
  @moduledoc false
  # Internal module for parsing TDMS values like integers, floating points, timestamps, strings, etc...
  #
  # The following data types are supported:
  #  - int8
  #  - int16
  #  - int32
  #  - int64
  #  - uint8
  #  - uint16
  #  - uint32
  #  - uint64
  #  - float
  #  - double
  #  - boolean
  #  - string
  #  - NI Timestamps (see https://www.ni.com/tutorial/7900/en/)
  #
  #  Integers, floats and NI Timestamps can be stored in big or little endian format
  #  depending on the bitmask value in the ToC (Table of Contents).

  alias TDMS.Parser.ParseError

  @base_ni_timestamp %DateTime{
    year: 1904,
    month: 1,
    day: 1,
    hour: 0,
    minute: 0,
    second: 0,
    microsecond: {0, 0},
    zone_abbr: "UTC",
    utc_offset: 0,
    std_offset: 0,
    time_zone: "Etc/UTC"
  }

  def parse_raw_strings(stream, count, endian) do
    {offsets, stream} = parse_int_array(stream, count, endian, [])
    parse_strings(stream, offsets, 0, [])
  end

  defp parse_int_array(stream, 0, _endian, result) do
    {Enum.reverse(result), stream}
  end

  defp parse_int_array(stream, count, endian, result) do
    {value, stream} = parse_value(stream, :uint32, endian)
    parse_int_array(stream, count - 1, endian, [value | result])
  end

  defp parse_strings(stream, [], _current_offset, results) do
    {Enum.reverse(results), stream}
  end

  defp parse_strings(stream, [offset | offsets], current_offset, results) do
    length = offset - current_offset
    <<value::binary-size(length), stream::binary>> = stream
    parse_strings(stream, offsets, offset, [value | results])
  end

  def parse_string(stream, endian) do
    {length, stream} = parse_value(stream, :uint32, endian)

    <<str::binary-size(length), stream::binary>> = stream
    {str, stream}
  end

  def parse_data_type(stream, endian) do
    {type, stream} = parse_value(stream, :uint32, endian)

    {convert_to_data_type(type), stream}
  end

  def parse_value(stream, :string, endian) do
    parse_string(stream, endian)
  end

  def parse_value(stream, :timestamp, :little) do
    {fractions, stream} = parse_unsigned_int(stream, 64, :little)
    {seconds_offset, stream} = parse_signed_int(stream, 64, :little)

    date = convert_to_timestamp(seconds_offset, fractions)
    {date, stream}
  end

  def parse_value(stream, :timestamp, :big) do
    {seconds_offset, stream} = parse_signed_int(stream, 64, :big)
    {fractions, stream} = parse_unsigned_int(stream, 64, :big)

    date = convert_to_timestamp(seconds_offset, fractions)
    {date, stream}
  end

  def parse_value(stream, :float, endian) do
    parse_float(stream, 32, endian)
  end

  def parse_value(stream, :double, endian) do
    parse_float(stream, 64, endian)
  end

  def parse_value(stream, :boolean, endian) do
    {value, stream} = parse_signed_int(stream, 8, endian)
    {value == 1, stream}
  end

  def parse_value(stream, :int8, endian) do
    parse_signed_int(stream, 8, endian)
  end

  def parse_value(stream, :int16, endian) do
    parse_signed_int(stream, 16, endian)
  end

  def parse_value(stream, :int32, endian) do
    parse_signed_int(stream, 32, endian)
  end

  def parse_value(stream, :int64, endian) do
    parse_signed_int(stream, 64, endian)
  end

  def parse_value(stream, :uint8, endian) do
    parse_unsigned_int(stream, 8, endian)
  end

  def parse_value(stream, :uint16, endian) do
    parse_unsigned_int(stream, 16, endian)
  end

  def parse_value(stream, :uint32, endian) do
    parse_unsigned_int(stream, 32, endian)
  end

  def parse_value(stream, :uint64, endian) do
    parse_unsigned_int(stream, 64, endian)
  end

  defp parse_float(stream, size, :big) do
    <<value::big-signed-float-size(size), stream::binary>> = stream
    {value, stream}
  end

  defp parse_float(stream, size, :little) do
    <<value::little-signed-float-size(size), stream::binary>> = stream
    {value, stream}
  end

  defp parse_unsigned_int(stream, size, :big) do
    <<value::big-unsigned-integer-size(size), stream::binary>> = stream
    {value, stream}
  end

  defp parse_unsigned_int(stream, size, :little) do
    <<value::little-unsigned-integer-size(size), stream::binary>> = stream
    {value, stream}
  end

  defp parse_signed_int(stream, size, :big) do
    <<value::big-signed-integer-size(size), stream::binary>> = stream
    {value, stream}
  end

  defp parse_signed_int(stream, size, :little) do
    <<value::little-signed-integer-size(size), stream::binary>> = stream
    {value, stream}
  end

  defp convert_to_timestamp(seconds_offset, fractions) do
    microseconds = Kernel.trunc(:math.pow(2, -64) * fractions * 1_000_000)

    %{
      datetime_add(@base_ni_timestamp, seconds_offset)
      | microsecond: {microseconds, 6}
    }
  end

  defp datetime_add(datetime, seconds) do
    datetime
    |> DateTime.to_unix()
    |> Kernel.+(seconds)
    |> DateTime.from_unix!()
  end

  defp convert_to_data_type(0x01) do
    :int8
  end

  defp convert_to_data_type(0x02) do
    :int16
  end

  defp convert_to_data_type(0x03) do
    :int32
  end

  defp convert_to_data_type(0x04) do
    :int64
  end

  defp convert_to_data_type(0x05) do
    :uint8
  end

  defp convert_to_data_type(0x06) do
    :uint16
  end

  defp convert_to_data_type(0x07) do
    :uint32
  end

  defp convert_to_data_type(0x08) do
    :uint64
  end

  defp convert_to_data_type(0x09) do
    :float
  end

  defp convert_to_data_type(0x0A) do
    :double
  end

  defp convert_to_data_type(0x20) do
    :string
  end

  defp convert_to_data_type(0x21) do
    :boolean
  end

  defp convert_to_data_type(0x44) do
    :timestamp
  end

  defp convert_to_data_type(value) do
    throw(ParseError.new("Unknown data type: #{value}"))
  end

  def data_type_to_property_value(:string) do
    "DT_STRING"
  end

  def data_type_to_property_value(:timestamp) do
    "DT_DATETIME"
  end

  def data_type_to_property_value(:float) do
    "DT_FLOAT"
  end

  def data_type_to_property_value(:double) do
    "DT_DOUBLE"
  end

  def data_type_to_property_value(:boolean) do
    "DT_BOOLEAN"
  end

  def data_type_to_property_value(:int8) do
    "DT_INT8"
  end

  def data_type_to_property_value(:int16) do
    "DT_INT16"
  end

  def data_type_to_property_value(:int32) do
    "DT_INT32"
  end

  def data_type_to_property_value(:int64) do
    "DT_INT64"
  end

  def data_type_to_property_value(:uint8) do
    "DT_UINT8"
  end

  def data_type_to_property_value(:uint16) do
    "DT_UINT16"
  end

  def data_type_to_property_value(:uint32) do
    "DT_UINT32"
  end

  def data_type_to_property_value(:uint64) do
    "DT_UINT64"
  end
end
