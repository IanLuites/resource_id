# ResourceID

[![Hex.pm](https://img.shields.io/hexpm/v/resource_id.svg "Hex")](https://hex.pm/packages/resource_id)
[![Build Status](https://travis-ci.org/IanLuites/resource_id.svg?branch=master)](https://travis-ci.org/IanLuites/resource_id)
[![Coverage Status](https://coveralls.io/repos/github/IanLuites/resource_id/badge.svg?branch=master)](https://coveralls.io/github/IanLuites/resource_id?branch=master)
[![Hex.pm](https://img.shields.io/hexpm/l/resource_id.svg "License")](LICENSE)

REST endpoints without PII in URLs.

## Quick Setup

```elixir
defmodule MyRouter do
  use Plug.Router

  plug ResourceID
  plug :match
  plug :dispatch

  get "/api/v1/users/:user/email" do
    ...
  end
end
```

## Configuration

### prefix

Prefix all headers with a set string.
This limits header user to only headers that start with the set prefix.

Example:
```elixir
plug ResourceID, prefix: "x-resource-"
```

## Installation

The package can be installed
by adding `resource_id` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:resource_id, "~> 1.0"}
  ]
end
```

The docs can be found at
[https://hexdocs.pm/resource_id](https://hexdocs.pm/resource_id).

## Changelog

### 1.0.0 (2020-02-15)

Initial release.

## Copyright and License

Copyright (c) 2020, Ian Luites.

ResourceID code is licensed under the [MIT License](LICENSE).
