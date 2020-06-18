defmodule TimerWeb.PageLive do
  use TimerWeb, :live_view
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, seconds: 3)}
  end

  @impl true
  def handle_event("start", _params, socket) do
    Logger.info("Start")
    {:noreply, socket}
  end

  def handle_event(event, params, socket) do
    Logger.warn("Received unexpected event #{inspect(event)} with params #{inspect(params)}")
    {:noreply, socket}
  end
end
