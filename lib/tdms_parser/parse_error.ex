defmodule TDMS.Parser.ParseError do
  @moduledoc false
  # Custom exception used internally inside of the parser to indicate a parser error.
  #
  # The exception is caught by the parser entry point and an error tuple
  # is returned instead

  defexception [:message]

  def new(message) do
    %__MODULE__{message: message}
  end
end
