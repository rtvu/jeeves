import {Socket} from "phoenix"
import clientID from "./client-id"

let socket = new Socket("/socket", {params: {token: window.userToken, client_id: clientID}})
socket.connect()

export default socket
