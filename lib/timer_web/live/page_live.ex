defmodule TimerWeb.PageLive do
  use Phoenix.LiveView
  require Logger

  def render(assigns) do
    Phoenix.View.render(TimerWeb.PageView, "index.html", assigns)
  end

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(seconds: 3, running: false)}
  end

  def handle_event("start", _data, socket) do
    tick()
    {:noreply, socket |> assign(running: true)}
  end

  def handle_event("stop", _data, socket) do
    {:noreply, socket |> assign(running: false)}
  end

  def handle_event(event, data, socket) do
    Logger.debug("Received event #{inspect(event)}, with data #{inspect(data)}")
    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    tick()
    {:noreply, socket |> assign(seconds: socket.assigns.seconds - 1)}
  end

  def handle_info(message, socket) do
    Logger.debug("Received message #{inspect(message)}")
    {:noreply, socket}
  end

  defp tick do
    Process.send_after(self(), :tick, 1000)
  end
end
