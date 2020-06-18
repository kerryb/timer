defmodule TimerWeb.PageLiveTest do
  use TimerWeb.ConnCase

  import Phoenix.LiveViewTest

  test "start time can be changed", %{conn: conn} do
    {:ok, view, html} = live(conn, "/")
    assert html =~ "3"

    view |> element("a.button", "Setup") |> render_click()
    view |> element("form") |> render_change(%{"seconds" => "10"})
    view |> element("submit", "Done") |> render_click()
    html = view |> element("a.button", "Reset") |> render_click()
    assert html =~ "10"
  end
end
