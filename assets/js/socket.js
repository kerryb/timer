import {Socket} from "phoenix"
import Klaxon from "./klaxon"

let socket = new Socket("/socket", {})

let channel = socket.channel("klaxon", {})

channel.on("sound", _payload => {
  Klaxon.sound()
})

channel.join()
  .receive("ok", resp => { })
  .receive("error", resp => { console.log("Unable to join", resp) })

socket.connect()

export default socket
