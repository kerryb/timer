defmodule TimerWeb.UserSocket do
  use Phoenix.Socket

  channel "klaxon", TimerWeb.KlaxonChannel

  def connect(_params, socket, _connect_info) do
    IO.puts("Joined")
    {:ok, socket}
  end

  def handle_in("klaxon", payload, socket) do
    IO.inspect(payload)
    {:noreply, socket}
  end

  def id(_socket), do: nil
end
