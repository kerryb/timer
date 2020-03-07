# Phoenix Live View

## Introduction

History?

Premonition (video?)

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
* Start clock ticking when start button pressed
    - tick using delayed message to self
* Add handler for reset button
* Stop ticking when timer is not running
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
    - could reply if required
* Print out unexpected messages
* Display message on screen
* Clear message after 3s
* Ignore start button when timer is at 0

Show inspector (what's on the socket?) at some point

# Conclusion

* A large subset of React etc, with no need to use two languages
* Obviously you could use Node, and all JS, but options are good
* Elixir and the BEAM have their own advantages (out of scope)
