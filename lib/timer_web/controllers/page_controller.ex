defmodule TimerWeb.PageController do
  use TimerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
