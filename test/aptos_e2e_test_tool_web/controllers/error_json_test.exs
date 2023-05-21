defmodule AptosE2eTestToolWeb.ErrorJSONTest do
  use AptosE2eTestToolWeb.ConnCase, async: true

  test "renders 404" do
    assert AptosE2eTestToolWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert AptosE2eTestToolWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
