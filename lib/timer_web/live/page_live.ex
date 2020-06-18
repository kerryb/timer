defmodule TimerWeb.PageLive do
  use TimerWeb, :live_view
  require Logger

  @default_seconds 3

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       seconds: @default_seconds,
       init_seconds: @default_seconds,
       running: false,
       finished: false
     )}
  end

  @impl true
  def handle_event("start", _params, socket) do
    Process.send_after(self(), :tick, 1000)
    {:noreply, assign(socket, running: true, finished: false)}
  end

  def handle_event("stop", _params, socket) do
    {:noreply, assign(socket, running: false)}
  end

  def handle_event("reset", _params, socket) do
    {:noreply,
     assign(socket, seconds: socket.assigns.init_seconds, running: false, finished: false)}
  end

  def handle_event("setup-change", %{"seconds" => seconds}, socket) do
    {:noreply, assign(socket, init_seconds: String.to_integer(seconds))}
  end

  def handle_event(event, params, socket) do
    Logger.warn("Received unexpected event #{inspect(event)} with params #{inspect(params)}")
    {:noreply, socket}
  end

  @impl true
  def handle_info(:tick, %{assigns: %{seconds: 1, running: true}} = socket) do
    {:noreply, assign(socket, seconds: 0, finished: true)}
  end

  def handle_info(:tick, %{assigns: %{running: true}} = socket) do
    Process.send_after(self(), :tick, 1000)
    {:noreply, assign(socket, seconds: socket.assigns.seconds - 1)}
  end

  def handle_info(:tick, socket) do
    {:noreply, socket}
  end

  def handle_info(message, socket) do
    Logger.warn("Received unexpected message #{inspect(message)}")
    {:noreply, socket}
  end
end
