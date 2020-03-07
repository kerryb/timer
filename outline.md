# Phoenix Live View

## Introduction

History?

Premonition (video?)

Points to note:

* Every client's instance of a live view is a process
* Millions of processes in one thread
* Event loop, similar to React etc
* Virtual DOM, with only diffs sent when the page changes
* Framework handles supervision, restarting, message loop etc

## Demo

* Start with static site
* Replace controller with dumb live view
    - no change to [lack of] behaviour
* Pass seconds remaining as an assign
* Add unhandled phx-click to start button
    - demonstrates declarative bindings
    - causes live view to crash and restart
* Print out unexpected events
    - event loop (pass socket/state back)
* Add handler for start button
    - just print out a message
    - demonstrates receiving events
    - pattern matching
* Toggle start/stop button
    - updating state
    - use chrome inspector to look at what's on the websocket
* Start clock ticking when start button pressed
    - tick using delayed message to self
* Add handler for reset button
    - reinforce binding and event handler
* Stop ticking when timer is not running
    - reinforce pattern matching
* Handle form input change to set start seconds
    - form bindings
    - data passed to live view
* Stop ticking when timer reaches 0
* Toggle setup pane display, and reset when done
    - conditional display
* Turn red when timer reaches zero
    - dynamic classes
* Sound klaxon when timer runs out
    - phoenix channels
    - javascript interop
* Listen for messages on PubSub channel
    - receive data from the rest of the app
    - channel forwards as a normal message to the server
    - `Phoenix.PubSub.broadcast Timer.PubSub, "notifications", {:message, "Hello!"}`
* Print out unexpected messages
    - could reply if required
* Display message on screen
    - just uses socket state like everything else
* Clear message after 3s
    - another example of sending ourselves a delayed message
* Ignore start button when timer is at 0
    - guard condition

# Conclusion

* A large subset of React etc, with no need to use two languages
* Obviously you could use Node, and all JS, but options are good
* Elixir and the BEAM have their own advantages (out of scope)
* Example used a single live view and template, but components allow
  modularisation
