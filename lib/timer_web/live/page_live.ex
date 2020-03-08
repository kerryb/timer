defmodule TimerWeb.PageLive do
  use Phoenix.LiveView
  require Logger

  def render(assigns) do
    Phoenix.View.render(TimerWeb.PageView, "index.html", assigns)
  end

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(seconds: 3)}
  end
end
