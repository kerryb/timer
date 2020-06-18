defmodule TimerWeb.PageLive do
  use TimerWeb, :live_view
  require Logger

  @default_seconds 3

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(Timer.PubSub, "messages")
    end

    {:ok,
     assign(socket,
       seconds: @default_seconds,
       init_seconds: @default_seconds,
       running: false,
       finished: false,
       setup: false
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

  def handle_event("open-setup", _params, socket) do
    {:noreply, assign(socket, setup: true)}
  end

  def handle_event("setup-change", %{"seconds" => seconds}, socket) do
    case Integer.parse(seconds) do
      {s, _} -> {:noreply, socket |> assign(init_seconds: s) |> clear_flash()}
      _ -> {:noreply, put_flash(socket, :error, "Invalid number")}
    end
  end

  def handle_event("close-setup", _params, socket) do
    {:noreply, assign(socket, setup: false)}
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

  def handle_info({:message, message}, socket) do
    Process.send_after(self(), :clear_message, 3000)
    {:noreply, put_flash(socket, :info, message)}
  end

  def handle_info(:clear_message, socket) do
    {:noreply, clear_flash(socket)}
  end

  def handle_info(message, socket) do
    Logger.warn("Received unexpected message #{inspect(message)}")
    {:noreply, socket}
  end
end
