defmodule TimerWeb.PageLive do
  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(TimerWeb.PageView, "index.html", assigns)
  end

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(seconds_remaining: 60, running: false)}
  end

  def handle_event("start", _data, socket) do
    Process.send_after(self(), :tick, 1000)
    {:noreply, socket |> assign(:running, true)}
  end

  def handle_event("stop", _data, socket) do
    {:noreply, socket |> assign(:running, false)}
  end

  def handle_event("reset", _data, socket) do
    {:noreply, socket |> assign(seconds_remaining: 60, running: false)}
  end

  def handle_info(:tick, %{assigns: %{running: true}} = socket) do
    Process.send_after(self(), :tick, 1000)
    {:noreply, socket |> assign(:seconds_remaining, socket.assigns.seconds_remaining - 1)}
  end

  def handle_info(:tick, socket) do
    {:noreply, socket}
  end
end
