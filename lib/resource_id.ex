defmodule ResourceID do
  @moduledoc ~S"""
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
  """
  @behaviour Plug

  @impl Plug
  def init(opts), do: %{prefix: Keyword.get(opts, :prefix, "")}

  @impl Plug
  def call(conn = %Plug.Conn{path_info: path, req_headers: headers}, %{prefix: prefix}) do
    %{conn | path_info: Enum.map(path, &resource(&1, headers, prefix))}
  end

  @spec resource(String.t(), [tuple], String.t()) :: String.t()
  defp resource(resource, headers, prefix)

  defp resource(value = "resource:" <> resource, headers, prefix) do
    case :binary.split(resource, ":") do
      [name] -> header(prefix <> name, headers) || value
      [name, select] -> select(header(prefix <> name, headers), select) || value
    end
  end

  defp resource(value, _headers, _prefix), do: value

  @spec header(String.t(), [String.t()]) :: String.t() | nil
  defp header(header, headers)
  defp header(_header, []), do: nil
  defp header(header, [{header, value} | _]), do: value
  defp header(header, [_ | headers]), do: header(header, headers)

  @spec select(String.t() | nil, String.t()) :: String.t() | nil
  defp select(header, match)
  defp select(nil, _match), do: nil

  defp select(header, match) do
    header
    |> String.split(",")
    |> Enum.find_value(fn entry ->
      case :binary.split(String.trim(entry), " ") do
        [^match, v] -> v
        _ -> false
      end
    end)
  end
end
