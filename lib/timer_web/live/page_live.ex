defmodule TimerWeb.PageLive do
  use Phoenix.LiveView
  require Logger

  @initial_seconds 3

  def render(assigns) do
    Phoenix.View.render(TimerWeb.PageView, "index.html", assigns)
  end

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(seconds: @initial_seconds, running: false)}
  end

  def handle_event("start", _data, socket) do
    tick()
    {:noreply, socket |> assign(running: true)}
  end

  def handle_event("stop", _data, socket) do
    {:noreply, socket |> assign(running: false)}
  end

  def handle_event("reset", _data, socket) do
    {:noreply, socket |> assign(seconds: @initial_seconds, running: false)}
  end

  def handle_event(event, data, socket) do
    Logger.debug("Received event #{inspect(event)}, with data #{inspect(data)}")
    {:noreply, socket}
  end

  def handle_info(:tick, %{assigns: %{running: true}} = socket) do
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
