defmodule TimerWeb.UserSocket do
  use Phoenix.Socket

  channel "klaxon", TimerWeb.KlaxonChannel

  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
