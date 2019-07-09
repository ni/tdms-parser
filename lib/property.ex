defmodule TDMS.Property do
  @moduledoc """
  Each `TDMS.Property` consists of a combination of a name (always a string), a type identifier, and a value.
  Typical data types for properties include numeric types such as integers or floating-point numbers,
  time stamps or strings.

  Every TDMS object can have an unlimited number of properties.

  ## Examples

      %TDMS.Property{data_type: :string, name: "name", value: "ai.0"}
      %TDMS.Property{data_type: :string, name: "datatype", value: "DT_DOUBLE"}
      %TDMS.Property{data_type: :timestamp, name: "wf_start_time", value: ~U[2019-06-09 23:48:50.982355Z]}
      %TDMS.Property{data_type: :double, name: "wf_start_offset", value: 0.0}
      %TDMS.Property{data_type: :double, name: "wf_increment", value: 3.0}
      %TDMS.Property{data_type: :int32, name: "wf_samples", value: 201}
      %TDMS.Property{data_type: :string, name: "NI_ChannelName", value: "ai.0"}
      %TDMS.Property{data_type: :string, name: "NI_UnitDescription", value: "Degrees Celsius"}
      %TDMS.Property{data_type: :string, name: "unit_string", value: "Degrees Celsius"}
  """

  defstruct [:name, :data_type, :value]

  @doc """
  Creates a new `TDMS.Property` structure
  """
  def new(
        name,
        data_type,
        value
      ) do
    %__MODULE__{
      name: name,
      data_type: data_type,
      value: value
    }
  end
end
