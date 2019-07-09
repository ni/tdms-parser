defmodule Test.TDMSWriter do
  use Bitwise

  @basic_toc 14
  @toc_interleaveddata 1 <<< 5
  @toc_bigendian 1 <<< 6

  @tdms_file_version_2 4713

  def write_lead_in(stream, opts \\ []) do
    endian = Keyword.get(opts, :endian, :little)
    interleaved = Keyword.get(opts, :interleaved, false)

    (stream <> "TDSm")
    |> write_toc(endian, interleaved)
    |> write_uint32(@tdms_file_version_2, endian)
    |> write_uint64(1, endian)
    |> write_uint64(1, endian)
  end

  def write_paths(stream, paths, opts \\ []) do
    endian = Keyword.get(opts, :endian, :little)

    stream
    |> write_uint32(length(paths), endian)
    |> write_path(paths, endian)
  end

  def write_data(stream, data) do
    stream <> data
  end

  def write_previous_raw_data_index(stream, paths, opts \\ []) do
    endian = Keyword.get(opts, :endian, :little)

    stream
    |> write_uint32(length(paths), endian)
    |> write_previous_raw_data_index_for_path(paths, endian)
  end

  defp write_previous_raw_data_index_for_path(stream, [], _endian) do
    stream
  end

  defp write_previous_raw_data_index_for_path(stream, [path | paths], endian) do
    stream
    |> write_string(path, endian)
    |> Kernel.<>(<<0, 0, 0, 0>> <> <<0, 0, 0, 0>>)
    |> write_previous_raw_data_index_for_path(paths, endian)
  end

  defp write_toc(stream, endian, interleaved) do
    toc =
      case endian do
        :little -> @basic_toc
        :big -> @basic_toc ||| @toc_bigendian
      end

    toc =
      case interleaved do
        false -> toc
        true -> toc ||| @toc_interleaveddata
      end

    write_uint32(stream, toc, :little)
  end

  defp write_path(stream, [], _endian) do
    stream
  end

  defp write_path(stream, [path | paths], endian) do
    stream
    |> write_string(path.path, endian)
    |> write_raw_data_index(path[:data_type], path[:number_of_values], endian)
    |> write_properties(path.properties, endian)
    |> write_path(paths, endian)
  end

  defp write_raw_data_index(stream, nil, _number_of_values, _endian) do
    stream <> <<255, 255, 255, 255>>
  end

  defp write_raw_data_index(stream, :string, number_of_values, endian) do
    stream
    |> write_basic_raw_data_index(:string, number_of_values, endian)
    |> write_uint64(0, endian)
  end

  defp write_raw_data_index(stream, data_type, number_of_values, endian) do
    stream
    |> write_basic_raw_data_index(data_type, number_of_values, endian)
  end

  defp write_basic_raw_data_index(stream, data_type, number_of_values, endian) do
    stream
    |> Kernel.<>(<<20, 0, 0, 0>>)
    |> write_datatype(data_type, endian)
    |> write_uint32(1, endian)
    |> write_uint64(number_of_values, endian)
  end

  defp write_properties(stream, properties, endian) do
    stream
    |> write_uint32(length(properties), endian)
    |> write_property(properties, endian)
  end

  defp write_property(stream, [], _endian) do
    stream
  end

  defp write_property(stream, [property | properties], endian) do
    stream
    |> write_string(property.name, endian)
    |> write_datatype(property.data_type, endian)
    |> write_value(property.data_type, property.value, endian)
    |> write_property(properties, endian)
  end

  defp write_datatype(stream, :int8, endian) do
    write_uint32(stream, 0x01, endian)
  end

  defp write_datatype(stream, :int16, endian) do
    write_uint32(stream, 0x02, endian)
  end

  defp write_datatype(stream, :int32, endian) do
    write_uint32(stream, 0x03, endian)
  end

  defp write_datatype(stream, :int64, endian) do
    write_uint32(stream, 0x04, endian)
  end

  defp write_datatype(stream, :uint8, endian) do
    write_uint32(stream, 0x05, endian)
  end

  defp write_datatype(stream, :uint16, endian) do
    write_uint32(stream, 0x06, endian)
  end

  defp write_datatype(stream, :uint32, endian) do
    write_uint32(stream, 0x07, endian)
  end

  defp write_datatype(stream, :uint64, endian) do
    write_uint32(stream, 0x08, endian)
  end

  defp write_datatype(stream, :float, endian) do
    write_uint32(stream, 0x09, endian)
  end

  defp write_datatype(stream, :double, endian) do
    write_uint32(stream, 0x0A, endian)
  end

  defp write_datatype(stream, :boolean, endian) do
    write_uint32(stream, 0x21, endian)
  end

  defp write_datatype(stream, :string, endian) do
    write_uint32(stream, 0x20, endian)
  end

  defp write_datatype(stream, :timestamp, endian) do
    write_uint32(stream, 0x44, endian)
  end

  defp write_value(stream, :uint32, value, endian) do
    write_uint32(stream, value, endian)
  end

  defp write_string(stream, value, endian) do
    stream
    |> write_uint32(byte_size(value), endian)
    |> Kernel.<>(value)
  end

  defp write_uint32(stream, value, endian) do
    write_unsigned(stream, value, 4, endian)
  end

  defp write_uint64(stream, value, endian) do
    write_unsigned(stream, value, 8, endian)
  end

  defp write_unsigned(stream, value, length, :big) do
    stream <> to_unsigned_binary(value, length)
  end

  defp write_unsigned(stream, value, length, :little) do
    stream <> reverse(to_unsigned_binary(value, length))
  end

  defp to_unsigned_binary(value, length) do
    pad_leading(:binary.encode_unsigned(value, :big), length, 0)
  end

  defp pad_leading(binary, len, _byte) when byte_size(binary) >= len do
    binary
  end

  defp pad_leading(binary, len, byte) do
    :binary.copy(<<byte>>, len - byte_size(binary)) <> binary
  end

  defp reverse(binary) do
    binary
    |> :binary.bin_to_list()
    |> Enum.reverse()
    |> :binary.list_to_bin()
  end
end
