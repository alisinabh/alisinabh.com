defmodule Alisinabh.IndexControllerTest do
  use Alisinabh.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "alisinabh"
  end
end
