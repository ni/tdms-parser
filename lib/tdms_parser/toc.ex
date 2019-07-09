defmodule TDMS.Parser.ToC do
  @moduledoc false
  # Internal module used to interpret ToC (Table of Contents) bitmasks.
  #
  # The lead in of the TDMS file (segment) contains a Table of Contents (ToC)
  # which indicates what kind of data the segment contains.
  #
  # Any combination of the following flags can be encoded in the ToC:
  #
  #   | Name               | Flag    | Description                                                                                                                          |
  #   | ------------------ | ------- | ------------------------------------------------------------------------------------------------------------------------------------ |
  #   | TocMetaData        | (1L<<1) | Segment contains meta data                                                                                                           |
  #   | TocRawData         | (1L<<3) | Segment contains raw data                                                                                                            |
  #   | TocDAQmxRawData    | (1L<<7) | Segment contains DAQmx raw data                                                                                                      |
  #   | TocInterleavedData | (1L<<5) | Raw data in the segment is interleaved (if flag is not set, data is contiguous)                                                      |
  #   | TocBigEndian       | (1L<<6) | All numeric values in the segment are big-endian formatted (if flag is not set, data is little-endian). ToC is always little-endian. |
  #   | TocNewObjList      | (1L<<2) | Segment contains new object list (e.g. channels in this segment are not the same channels the previous segment contains)             |

  use Bitwise

  @toc_metadata 1 <<< 1
  @toc_rawdata 1 <<< 3
  @toc_daqmxrawdata 1 <<< 7
  @toc_interleaveddata 1 <<< 5
  @toc_bigendian 1 <<< 6
  @toc_newobjlist 1 <<< 2

  @doc """
  Checks if the segment contains meta data

  ## Examples

      iex> TDMS.Parser.ToC.has_metadata(0x0E)
      true
  """
  def has_metadata(toc) do
    has_flag(@toc_metadata, toc)
  end

  @doc """
  Checks if the segment contains raw data

  ## Examples

      iex> TDMS.Parser.ToC.has_rawdata(0x0E)
      true
  """
  def has_rawdata(toc) do
    has_flag(@toc_rawdata, toc)
  end

  @doc """
  Checks if the segment contains DAQmx raw data

  ## Examples

      iex> TDMS.Parser.ToC.has_daqmx_rawdata(0x0E)
      false
  """
  def has_daqmx_rawdata(toc) do
    has_flag(@toc_daqmxrawdata, toc)
  end

  @doc """
  Checks if the segment contains a new set of channel definitions

  ## Examples

      iex> TDMS.Parser.ToC.has_new_object_list(0x0E)
      false
  """
  def has_new_object_list(toc) do
    has_flag(@toc_newobjlist, toc)
  end

  @doc """
  Checks if the segment data is interleaved

  ## Examples

      iex> TDMS.Parser.ToC.is_interleaved(0x0E)
      false
  """
  def is_interleaved(toc) do
    has_flag(@toc_interleaveddata, toc)
  end

  @doc """
  Checks if the segment values are formatted in big endian

  ## Examples

      iex> TDMS.Parser.ToC.is_big_endian(0x0E)
      false
  """
  def is_big_endian(toc) do
    has_flag(@toc_bigendian, toc)
  end

  defp has_flag(flag, int) do
    (flag &&& int) == flag
  end
end
