defmodule HttpServerTest do
  use ExUnit.Case, async: false
  use Plug.Test

  test "no entries" do
    assert get("/entries?list=test_1&date=2018-12-19").status == 200
    assert get("/entries?list=test_1&date=2018-12-19").resp_body == ""
  end

  test "adding an entry" do
    resp = post("/add_entry?list=test_2&date=2018-12-19&title=Dentist")

    assert resp.status == 200
    assert resp.resp_body == "OK"
    assert get("/entries?list=test_2&date=2018-12-19").resp_body == "2018-12-19 Dentist"
  end

  defp get(path) do
    Todo.Web.call(conn(:get, path), Todo.Web.init([]))
  end

  defp post(path) do
    Todo.Web.call(conn(:post, path), Todo.Web.init([]))
  end
end
