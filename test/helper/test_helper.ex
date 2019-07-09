defmodule Test.Helper do
  def find_group(tdms_file, group_name) do
    Enum.find(tdms_file.groups, fn group -> group.name == group_name end)
  end

  def find_channel(tdms_file, group_name, channel_name) do
    case find_group(tdms_file, group_name) do
      nil -> nil
      group -> Enum.find(group.channels, fn channel -> channel.name == channel_name end)
    end
  end
end
