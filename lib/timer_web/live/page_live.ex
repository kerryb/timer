defmodule TimerWeb.PageLive do
  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(TimerWeb.PageView, "index.html", assigns)
  end

  def mount(_params, _session, socket) do
    {:ok,
     socket |> assign(setup: false, start_seconds: 60, seconds_remaining: 60, running: false)}
  end

  def handle_event("start", _data, socket) do
    Process.send_after(self(), :tick, 1000)
    {:noreply, socket |> assign(:running, true)}
  end

  def handle_event("stop", _data, socket) do
    {:noreply, socket |> assign(:running, false)}
  end

  def handle_event("reset", _data, socket) do
    {:noreply, socket |> assign(seconds_remaining: socket.assigns.start_seconds, running: false)}
  end

  def handle_event("setup", _data, socket) do
    {:noreply, socket |> assign(setup: true, running: false)}
  end

  def handle_event("setup-done", _data, socket) do
    {:noreply, socket |> assign(setup: false, seconds_remaining: socket.assigns.start_seconds)}
  end

  def handle_event("setup-change", %{"seconds" => seconds}, socket) do
    {:noreply, socket |> assign(start_seconds: String.to_integer(seconds), running: false)}
  end

  def handle_info(:tick, %{assigns: %{seconds_remaining: 0}} = socket) do
    TimerWeb.Endpoint.broadcast!("klaxon", "sound", %{})
    {:noreply, socket}
  end

  def handle_info(:tick, %{assigns: %{running: true}} = socket) do
    Process.send_after(self(), :tick, 1000)
    {:noreply, socket |> assign(:seconds_remaining, socket.assigns.seconds_remaining - 1)}
  end

  def handle_info(:tick, socket) do
    {:noreply, socket}
  end
end
