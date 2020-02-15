defmodule ResourceIDTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias Plug.Conn
  import ResourceID

  defp conn_call(url, opts \\ []) do
    conn = opts |> Keyword.get(:verb, :get) |> conn(url)

    opts
    |> Keyword.get(:headers, [])
    |> Enum.reduce(conn, fn {k, v}, c -> Conn.put_req_header(c, String.downcase(k), v) end)
    |> call(init(opts))
  end

  describe "init/1" do
    test "configures `prefix` if passed" do
      assert init(prefix: "x-resource-").prefix == "x-resource-"
    end

    test "defaults prefix to empty if not set" do
      assert init([]).prefix == ""
      assert init(setting: "value").prefix == ""
    end
  end

  describe "call/2" do
    test "keeps passed values if no matching header is found" do
      # No Headers
      conn = conn_call("/api/v1/users/resource:user/field")

      assert ["api", "v1", "users", user, "field"] = conn.path_info
      assert user == "resource:user"

      # Wrong headers
      conn = conn_call("/api/v1/users/resource:user/field", headers: %{"account" => "54321"})

      assert ["api", "v1", "users", user, "field"] = conn.path_info
      assert user == "resource:user"
    end

    test "replaces patch value with value from header" do
      conn = conn_call("/api/v1/users/resource:user/field", headers: %{"user" => "98765"})

      assert ["api", "v1", "users", user, "field"] = conn.path_info
      assert user == "98765"
    end

    test "keeps request path set to original (No leaks)" do
      conn = conn_call("/api/v1/users/resource:user/field", headers: %{"user" => "98765"})

      assert conn.request_path == "/api/v1/users/resource:user/field"
    end

    test "prefix is prefixed before every passed resource" do
      conn =
        conn_call("/api/v1/users/resource:user/field",
          prefix: "x-resource-",
          headers: %{"X-Resource-User" => "12345"}
        )

      assert ["api", "v1", "users", user, "field"] = conn.path_info
      assert user == "12345"
    end

    test "fetch from `,` delimited header with multiple values" do
      conn =
        conn_call("/api/v1/users/resource:authorization:user/field",
          headers: %{"Authorization" => "Bearer ae7238df12457d, user 83727, account 38ewu32we8"}
        )

      assert ["api", "v1", "users", user, "field"] = conn.path_info
      assert user == "83727"
    end
  end
end
