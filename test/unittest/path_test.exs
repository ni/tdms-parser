defmodule Test.UnitTest.TDMSPathTest do
  use ExUnit.Case

  @tag unittest: true
  test "Path.get_name returns group name" do
    result = TDMS.Parser.Path.get_name("/my-group")

    assert result == "my-group"
  end

  @tag unittest: true
  test "Path.get_name returns channel" do
    result = TDMS.Parser.Path.get_name("/my-group/my-channel")

    assert result == "my-channel"
  end

  @tag unittest: true
  test "Path.get_name returns group name without quotes" do
    result = TDMS.Parser.Path.get_name("/'my-group'")

    assert result == "my-group"
  end

  @tag unittest: true
  test "Path.get_name returns channel without quotes" do
    result = TDMS.Parser.Path.get_name("/'my-group'/'my-channel'")

    assert result == "my-channel"
  end

  @tag unittest: true
  test "Path.get_name returns group name with slash inside of the quotes" do
    result = TDMS.Parser.Path.get_name("/'my/group'")

    assert result == "my/group"
  end

  @tag unittest: true
  test "Path.depth return 1 for '/'" do
    result = TDMS.Parser.Path.depth("/")

    assert result == 1
  end

  @tag unittest: true
  test "Path.depth return 2 for groups" do
    result = TDMS.Parser.Path.depth("/my-group")

    assert result == 2
  end

  @tag unittest: true
  test "Path.depth return 2 for groups with slash in name" do
    result = TDMS.Parser.Path.depth("/'my-gro/up'")

    assert result == 2
  end

  @tag unittest: true
  test "Path.depth return 3 for channels" do
    result = TDMS.Parser.Path.depth("/my-group/my-channel")

    assert result == 3
  end

  @tag unittest: true
  test "Path.is_child returns true for channel in group" do
    result = TDMS.Parser.Path.is_child("/my-group/my-channel", "/my-group")

    assert result == true
  end

  @tag unittest: true
  test "Path.is_child returns false for channel in different group" do
    result = TDMS.Parser.Path.is_child("/my-group/my-channel", "/my-other-group")

    assert result == false
  end

  @tag unittest: true
  test "Path.is_child returns true for quoted channel in group" do
    result = TDMS.Parser.Path.is_child("/'my-group'/'my-channel'", "/'my-group'")

    assert result == true
  end
end
