defmodule TimerWeb.PageLive do
  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(TimerWeb.PageView, "index.html", assigns)
  end

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:seconds_remaining, 60)}
  end

  def handle_event("start", _data, socket) do
    IO.puts("Start button pressed")
    {:noreply, socket}
  end
end
