defmodule TimerWeb.PageLive do
  use Phoenix.LiveView
  require Logger

  @initial_seconds 3

  def render(assigns) do
    Phoenix.View.render(TimerWeb.PageView, "index.html", assigns)
  end

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(Timer.PubSub, "notifications")
    end

    {:ok,
     socket
     |> assign(
       initial_seconds: @initial_seconds,
       seconds: @initial_seconds,
       running: false,
       finished: false,
       setup: false,
       message: nil
     )}
  end

  def handle_event("start", _data, socket) do
    tick()
    {:noreply, socket |> assign(running: true)}
  end

  def handle_event("stop", _data, socket) do
    {:noreply, socket |> assign(running: false)}
  end

  def handle_event("reset", _data, socket) do
    {:noreply,
     socket |> assign(seconds: socket.assigns.initial_seconds, running: false, finished: false)}
  end

  def handle_event("setup", _data, socket) do
    {:noreply, socket |> assign(setup: true)}
  end

  def handle_event("setup-done", _data, socket) do
    {:noreply, socket |> assign(setup: false)}
  end

  def handle_event("setup-change", %{"seconds" => seconds}, socket) do
    {:noreply, socket |> assign(initial_seconds: seconds)}
  end

  def handle_event(event, data, socket) do
    Logger.debug("Received event #{inspect(event)}, with data #{inspect(data)}")
    {:noreply, socket}
  end

  def handle_info(:tick, %{assigns: %{seconds: seconds, running: true}} = socket)
      when seconds == 1 do
    TimerWeb.Endpoint.broadcast!("klaxon", "sound", %{})

    {:noreply,
     socket |> assign(seconds: socket.assigns.seconds - 1, running: false, finished: true)}
  end

  def handle_info(:tick, %{assigns: %{running: true}} = socket) do
    tick()
    {:noreply, socket |> assign(seconds: socket.assigns.seconds - 1)}
  end

  def handle_info({:message, message}, socket) do
    Process.send_after(self(), :clear_message, 3000)
    {:noreply, socket |> assign(:message, message)}
  end

  def handle_info(:clear_message, socket) do
    {:noreply, socket |> assign(:message, nil)}
  end

  def handle_info(message, socket) do
    Logger.debug("Received message #{inspect(message)}")
    {:noreply, socket}
  end

  defp tick do
    Process.send_after(self(), :tick, 1000)
  end
end
