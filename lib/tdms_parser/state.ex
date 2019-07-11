defmodule TDMS.Parser.State do
  @moduledoc false
  # Internal state of the TDMS parser.
  #
  # This structure is used to keep track of the metadata for each segment in the
  # TDMS file. It also stores the parsed results."

  defstruct [:lead_in, :paths, :raw_data_indexes]

  def new() do
    %__MODULE__{
      lead_in: nil,
      paths: %{},
      raw_data_indexes: []
    }
  end

  def set_lead_in(state, lead_in) do
    %{state | lead_in: lead_in, raw_data_indexes: []}
  end

  def get_path_info(state, path) do
    state.paths[path]
  end

  def add_metadata(state, path, properties, raw_data_index) do
    data =
      case state.paths[path] do
        nil -> []
        result -> result.data
      end

    result = %{
      properties: properties,
      raw_data_index: raw_data_index,
      data: data,
      order: map_size(state.paths) + 1
    }

    %{state | paths: Map.put(state.paths, path, result)}
  end

  def get_data(state, path) do
    result = state.paths[path]
    List.flatten(result.data)
  end

  def add_data(state, path, data) do
    result = state.paths[path]
    result = %{result | data: [result.data | data]}

    %{
      state
      | paths: Map.put(state.paths, path, result)
    }
  end

  def get_raw_data_indexes(state) do
    Enum.reverse(state.raw_data_indexes)
  end

  def add_raw_data_index(state, raw_data_index) do
    %{state | raw_data_indexes: [raw_data_index | state.raw_data_indexes]}
  end
end
