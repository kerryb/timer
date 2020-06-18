defmodule TimerWeb.PageLive do
  use TimerWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, seconds: 3)}
  end
end
