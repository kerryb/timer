import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

let socket = new Socket("/socket", {})

socket.connect()

channel.join()
  .receive("ok", resp => { })
  .receive("error", resp => { console.log("Unable to join", resp) })

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}});
liveSocket.connect()

export default socket
