import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

let channel = socket.channel("file_explorer:find", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.push("path", { path: "c/.." })
  .receive("ok", resp => { console.log("Joined successfully", resp.path_crumb) })

export default socket
