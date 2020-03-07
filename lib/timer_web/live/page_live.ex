defmodule TimerWeb.PageLive do
  use Phoenix.LiveView

  @default_time 3

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
       setup: false,
       start_seconds: @default_time,
       seconds_remaining: @default_time,
       running: false,
       message: nil
     )}
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

  def handle_info(:tick, %{assigns: %{seconds_remaining: 1}} = socket) do
    TimerWeb.Endpoint.broadcast!("klaxon", "sound", %{})

    {:noreply,
     socket |> assign(running: false, seconds_remaining: socket.assigns.seconds_remaining - 1)}
  end

  def handle_info(:tick, %{assigns: %{running: true}} = socket) do
    Process.send_after(self(), :tick, 1000)
    {:noreply, socket |> assign(:seconds_remaining, socket.assigns.seconds_remaining - 1)}
  end

  def handle_info({:message, message}, socket) do
    Process.send_after(self(), :clear_message, 3000)
    {:noreply, socket |> assign(:message, message)}
  end

  def handle_info(:clear_message, socket) do
    {:noreply, socket |> assign(:message, nil)}
  end

  def handle_info(_, socket) do
    {:noreply, socket}
  end
end
