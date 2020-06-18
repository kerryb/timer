defmodule TimerWeb.PageLive do
  use TimerWeb, :live_view
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, seconds: 3, running: false)}
  end

  @impl true
  def handle_event("start", _params, socket) do
    Process.send_after(self(), :tick, 1000)
    {:noreply, assign(socket, running: true)}
  end

  def handle_event(event, params, socket) do
    Logger.warn("Received unexpected event #{inspect(event)} with params #{inspect(params)}")
    {:noreply, socket}
  end

  @impl true
  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 1000)
    {:noreply, assign(socket, seconds: socket.assigns.seconds - 1)}
  end

  def handle_info(message, socket) do
    Logger.warn("Received unexpected message #{inspect(message)}")
    {:noreply, socket}
  end
end
