defmodule TDMS.Channel do
  @moduledoc """
  Data structure for channels. Channels contain the actual data which is defined
  by the data type.

  ## Examples

      %TDMS.Channel{
        data: [24.172693869632123, 24.238202284912816, 24.22418907461031, ...],
        data_count: 201,
        data_type: :double,
        name: "ai.0",
        path: "/'Temperature'/'ai.0'",
        properties: [
          %TDMS.Property{data_type: :string, name: "name", value: "ai.0"},
          %TDMS.Property{data_type: :string, name: "datatype", value: "DT_DOUBLE"}
        ]
      }
  """

  defstruct [:path, :name, :data_type, :data_count, :properties, :data]

  @doc """
  Creates a new `TDMS.Channel` structure
  """
  def new(path, name, data_type, data_count, properties, data) do
    %__MODULE__{
      path: path,
      name: name,
      data_type: data_type,
      data_count: data_count,
      properties: properties,
      data: data
    }
  end
end
