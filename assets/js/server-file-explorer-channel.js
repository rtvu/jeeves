import socket from "./socket"

let serverFileExplorerChannel = socket.channel("file_explorer:channel", {})
serverFileExplorerChannel.join()
  .receive("ok", resp => { console.log("ServerFileExplorerChannel joined successfully.") })
  .receive("error", resp => { console.log("Unable to join ServerFileExplorerChannel.") })

export default serverFileExplorerChannel
