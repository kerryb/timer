defmodule TimerWeb.PageLive do
  use TimerWeb, :live_view
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
