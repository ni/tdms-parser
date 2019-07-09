defmodule TDMS.Group do
  @moduledoc """
  Data structure for channel groups. Each group can contain several `TDMS.Channel`.

  ## Examples

      %TDMS.Group{
        name: "Temperature",
        path: "/'Temperature'",
        properties: [
          %TDMS.Property{data_type: :string, name: "name", value: "Temperature"}
        ],
        channels: [%TDMS.Channel{...}]
      }
  """

  defstruct [:path, :name, :properties, :channels]

  @doc """
  Creates a new `TDMS.Group` structure
  """
  def new(path, name, properties, channels) do
    %__MODULE__{
      path: path,
      name: name,
      properties: properties,
      channels: channels
    }
  end
end
