defmodule HttpServerTest do
  use ExUnit.Case, async: false

  test "http server" do
    assert %HTTPoison.Response{body: "", status_code: 200} =
             HTTPoison.get!("http://127.0.0.1:5454/entries?list=test&date=20181219")

    assert %HTTPoison.Response{body: "OK", status_code: 200} =
             HTTPoison.post!(
               "http://127.0.0.1:5454/add_entry?list=test&date=20181219&title=Dentist",
               ""
             )

    assert %HTTPoison.Response{body: "2018-12-19    Dentist", status_code: 200} =
             HTTPoison.get!("http://127.0.0.1:5454/entries?list=test&date=20181219")
  end
end
