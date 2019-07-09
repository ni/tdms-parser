defmodule TDMS.File do
  @moduledoc """
  The main data structure returned by the TDMS parser.

  TDMS files organize data in a three-level hierarchy of objects.
  The top level is comprised of a single object that holds file-specific information like author or title.

  `TDMS.File` contains a list of `TDMS.Property` and `TDMS.Group`.

  ## Examples

      %TDMS.File{
        path: "/",
        properties: [
          %TDMS.Property{
            data_type: :string,
            name: "name",
            value: "ni-crio-9068-190fdf5_20190609_235850.tdms"
          }
        ],
        groups: [%TDMS.Group{...}]
      }

  """
  defstruct [:path, :properties, :groups]

  @doc """
  Creates a new `TDMS.File` structure
  """
  def new(path, properties, groups) do
    %__MODULE__{
      path: path,
      properties: properties,
      groups: groups
    }
  end
end
