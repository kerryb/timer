defmodule TimerWeb.KlaxonChannel do
  use TimerWeb, :channel

  def join("klaxon", _payload, socket) do
    {:ok, socket}
  end
end
