import {Socket} from "phoenix"
import clientID from "./client-id"

let isConnected = false
let socket = new Socket("/socket", {params: {token: window.userToken, client_id: clientID}})

function getSocket() {
  if (!isConnected) {
    isConnected = true

    socket.connect()
  }

  return socket
}

export default getSocket
