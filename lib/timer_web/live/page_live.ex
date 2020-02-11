defmodule TimerWeb.PageLive do
  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(TimerWeb.PageView, "index.html", assigns)
  end

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:seconds_remaining, 60)}
  end
end
