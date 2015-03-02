defmodule HttpServerTest do
  use ExUnit.Case, async: false

  setup do
    File.rm_rf("./persist/")
    File.rm_rf("Mnesia.nonode@nohost")
    {:ok, apps} = Application.ensure_all_started(:todo)
    HTTPoison.start

    on_exit fn ->
      Enum.each(apps, &Application.stop/1)
    end

    :ok
  end

  test "http server" do
    assert %HTTPoison.Response{body: "", status_code: 200} =
      HTTPoison.get("http://127.0.0.1:5454/entries?list=test&date=20131219")

    assert %HTTPoison.Response{body: "OK", status_code: 200} =
      HTTPoison.post("http://127.0.0.1:5454/add_entry?list=test&date=20131219&title=Dentist", "")

    assert %HTTPoison.Response{body: "2013-12-19    Dentist\n", status_code: 200} =
      HTTPoison.get("http://127.0.0.1:5454/entries?list=test&date=20131219")
  end
end