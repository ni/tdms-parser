# TDMS.Parser

[![Hex.pm Version](https://img.shields.io/hexpm/v/tdms_parser.svg?style=flat)](https://hex.pm/packages/tdms_parser) [![Build Status](https://travis-ci.org/ni/tdms-parser.svg?branch=master)](https://travis-ci.org/ni/tdms-parser) [![Coverage Status](https://coveralls.io/repos/github/ni/tdms-parser/badge.svg?branch=master)](https://coveralls.io/github/ni/tdms-parser?branch=master)

Parser for NI TDMS files written in Elixir. The TDMS file parser is implemented natively in elixir and comes with zero-dependencies.

You can see the API documentation [here](https://hexdocs.pm/tdms_parser).

## Installation

The package can be installed by adding `tdms_parser` to your list of dependencies in `mix.exs`:

```elixir
defp deps do
  [
    {:tdms_parser, "~> 0.0"}
  ]
end
```

## Usage

The following command parses the given file and returns a TDMS.File structure.

```elixir
iex> TDMS.Parser.parse(File.read!("test/data/basic.tdms"))
```

## TDMS File Format

The single, most important feature to understand about the internal format of the TDMS file structure is its inherent hierarchical organization. The TDMS file format is structured using three levels of hierarchy: file, group, and channel. The file level can contain groups, and each group can contain multiple channels.

The high-level description of the TDMS file format can be found at [The NI TDMS File Format](https://www.ni.com/product-documentation/3727/en/). 

For a detailed description of all fields, their data types and byte representations see [TDMS File Format Internal Structure](https://www.ni.com/product-documentation/5696/en/).

## Data Structures

```elixir
%TDMS.File{
  path: "/",
  properties: [
    %TDMS.Property{
      data_type: :string,
      name: "name",
      value: "ni-crio-9068-190fdf5_20190609_235850.tdms"
    }
  ],
  groups: [
    %TDMS.Group{
      name: "Temperature",
      path: "/'Temperature'",
      properties: [
        %TDMS.Property{data_type: :string, name: "name", value: "Temperature"}
      ]
      channels: [
        %TDMS.Channel{
          data: [24.172693869632123, 24.238202284912816, 24.22418907461031, ...],
          data_count: 201,
          data_type: :double,
          name: "ai.0",
          path: "/'Temperature'/'ai.0'",
          properties: [
            %TDMS.Property{data_type: :string, name: "name", value: "ai.0"},
            %TDMS.Property{
              data_type: :string,
              name: "datatype",
              value: "DT_DOUBLE"
            },
            ...
          ]
        },
        %TDMS.Channel{
          data: [24.07053512461277, 24.136787008557807, 24.128304594848682, ...],
          data_count: 201,
          data_type: :double,
          name: "ai.1",
          path: "/'Temperature'/'ai.1'",
          properties: [
            %TDMS.Property{data_type: :string, name: "name", value: "ai.1"},
            %TDMS.Property{
              data_type: :string,
              name: "datatype",
              value: "DT_DOUBLE"
            },
            ...
          ]
        },
        ...
      ]
    }
  ]
}
```

## Build and Test

Build:
```elixir
mix compile
```

Run the unit tests:
```elixir
mix test --only unittest
```

Run the integration tests:
```elixir
mix test --only integration
```