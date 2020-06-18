# Phoenix Live View

## Introduction

* History
* Premonition (video)
* Points to note:
    - Every client's instance of a live view is a process
    - Millions of processes in one thread
    - Event loop, similar to React etc
    - Events are processed sequentially within a process
    - Separate processes run in parallel
    - Virtual DOM, with only diffs sent when the page changes
    - Framework handles supervision, restarting, message loop etc

## Demo

1. Start with static template
1. Pass seconds remaining as an assign
    ```elixir
    def mount(_params, _session, socket) do
      {:ok, assign(socket, seconds: 3)}
    end
    ```    
    ```html+eex
    <div class="timer"><%= @seconds %></div>
    ```
1. Add unhandled phx-click to start button
    ```html+eex
    <a class="button" href="#" phx-click="start">Start</a>
    ```
    - demonstrates declarative bindings
    - causes live view to crash and restart
1. Log unexpected events
    ```elixir
    @impl true
    def handle_event(event, params, socket) do
      Logger.warn("Received unexpected event #{inspect(event)} with params #{inspect(params)}")
      {:noreply, socket}
    end
    ```
    - event loop (pass socket/state back)
1. Add handler for start event
    ```elixir
    @impl true
    def handle_event("start", _params, socket) do
      Logger.info("Start")
      {:noreply, socket}
    end
    ```
    - just print out a message
    - demonstrates receiving events
    - pattern matching
1. Toggle start/stop button
    ```elixir
    @impl true
    def mount(_params, _session, socket) do
      {:ok, assign(socket, seconds: 3, running: false)}
    end

    @impl true
    def handle_event("start", _params, socket) do
      {:noreply, assign(socket, running: true)}
    end
    ```
    ```html+eex
    <%= if @running do %>
      <a class="button" href="#" phx-click="stop">Stop</a>
    <% else %>
      <a class="button" href="#" phx-click="start">Start</a>
    <% end %>
    ```
    - updating state
1. Start clock ticking when start button pressed
    ```elixir
    def handle_event("start", _params, socket) do
      Process.send_after(self(), :tick, 1000)
      {:noreply, assign(socket, running: true)}
    end

    @impl true
    def handle_info(:tick, socket) do
      Process.send_after(self(), :tick, 1000)
      {:noreply, assign(socket, seconds: socket.assigns.seconds - 1)}
    end

    def handle_info(message, socket) do
      Logger.warn("Received unexpected message #{inspect(message)}")
      {:noreply, socket}
    end
    ```
    - tick using delayed message to self
1. Stop ticking when timer is not running
    ```elixir
    def handle_event("stop", _params, socket) do
      {:noreply, assign(socket, running: false)}
    end

    def handle_info(:tick, %{assigns: %{running: true}} = socket) do
      Process.send_after(self(), :tick, 1000)
      {:noreply, assign(socket, seconds: socket.assigns.seconds - 1)}
    end

    def handle_info(:tick, socket) do
      {:noreply, socket}
    end
    ```
    - reinforce pattern matching
    - use chrome inspector to look at what's on the websocket
1. Add handler for reset button
    ```elixir
    def handle_event("reset", _params, socket) do
      {:noreply, assign(socket, seconds: 3, running: false)}
    end
    ```
    ```html+eex
    <a class="button button-outline" href="#" phx-click="reset">Reset</a>
    ```
    - reinforce binding and event handler
    - extract magic `3` to a module attribute
1. Handle form input change to set start seconds
    - form bindings
    - data passed to live view
1. Stop ticking when timer reaches 0
1. Turn red when timer reaches zero
    - dynamic classes
1. Toggle setup pane display, and reset when done
    - conditional display
1. Sound klaxon when timer runs out
    - phoenix channels
    - javascript interop

### Optional additional steps if time

1. Listen for messages on PubSub channel
    - receive data from the rest of the app
    - channel forwards as a normal message to the server
    - `Phoenix.PubSub.broadcast Timer.PubSub, "notifications", {:message, "Hello!"}`
1. Print out unexpected messages
    - could reply if required
1. Display message on screen
    - just uses socket state like everything else
1. Clear message after 3s
    - another example of sending ourselves a delayed message
1. Ignore start button when timer is at 0
    - guard condition

# Conclusion

* A large subset of React etc, with no need to use two languages
* Obviously you could use Node, and all JS, but options are good
* Elixir and the BEAM have their own advantages (out of scope)
* Example used a single live view and template, but components allow
  modularisation
* Also wouldn't put all the business logic in the web app
