defmodule Test.UnitTest.TDMSToCTest do
  use ExUnit.Case

  alias TDMS.Parser.ToC

  @tag unittest: true
  test "ToC.has_metadata returns true for 0b00000010" do
    result = ToC.has_metadata(0b00000010)
    assert result == true
  end

  @tag unittest: true
  test "ToC.has_metadata returns false for 0b00000100" do
    result = ToC.has_metadata(0b00000100)
    assert result == false
  end

  @tag unittest: true
  test "ToC.has_metadata returns true for 0b00000011" do
    result = ToC.has_metadata(0b00000011)
    assert result == true
  end

  @tag unittest: true
  test "ToC.has_rawdata returns true for 0b00001000" do
    result = ToC.has_rawdata(0b00001000)
    assert result == true
  end

  @tag unittest: true
  test "ToC.has_rawdata returns false for 0b00000100" do
    result = ToC.has_rawdata(0b00000100)
    assert result == false
  end

  @tag unittest: true
  test "ToC.has_rawdata returns true for 0b00101100" do
    result = ToC.has_rawdata(0b00101100)
    assert result == true
  end

  @tag unittest: true
  test "ToC.has_daqmx_rawdata returns true for 0b10000000" do
    result = ToC.has_daqmx_rawdata(0b10000000)
    assert result == true
  end

  @tag unittest: true
  test "ToC.has_daqmx_rawdata returns false for 0b00000001" do
    result = ToC.has_daqmx_rawdata(0b00000001)
    assert result == false
  end

  @tag unittest: true
  test "ToC.has_daqmx_rawdata returns true for 0b11111111" do
    result = ToC.has_daqmx_rawdata(0b11111111)
    assert result == true
  end

  @tag unittest: true
  test "ToC.has_new_object_list returns true for 0b00000100" do
    result = ToC.has_new_object_list(0b00000100)
    assert result == true
  end

  @tag unittest: true
  test "ToC.has_new_object_list returns false for 0b00000001" do
    result = ToC.has_new_object_list(0b00000001)
    assert result == false
  end

  @tag unittest: true
  test "ToC.has_new_object_list returns true for 0b10000100" do
    result = ToC.has_new_object_list(0b10000100)
    assert result == true
  end

  @tag unittest: true
  test "ToC.is_interleaved returns true for 0b00100000" do
    result = ToC.is_interleaved(0b00100000)
    assert result == true
  end

  @tag unittest: true
  test "ToC.is_interleaved returns false for 0b00010000" do
    result = ToC.is_interleaved(0b00010000)
    assert result == false
  end

  @tag unittest: true
  test "ToC.is_interleaved returns true for 0b00110100" do
    result = ToC.is_interleaved(0b00110100)
    assert result == true
  end

  @tag unittest: true
  test "ToC.is_big_endian returns true for 0b01000000" do
    result = ToC.is_big_endian(0b01000000)
    assert result == true
  end

  @tag unittest: true
  test "ToC.is_big_endian returns false for 0b00010000" do
    result = ToC.is_big_endian(0b00010000)
    assert result == false
  end

  @tag unittest: true
  test "ToC.is_big_endian returns true for 0b01110100" do
    result = ToC.is_big_endian(0b01110100)
    assert result == true
  end
end
