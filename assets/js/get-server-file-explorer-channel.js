import getSocket from "./get-socket"

let isInitialized = false
let serverFileExplorerChannel = null

function getServerFileExplorerChannel() {
  if (!isInitialized) {
    isInitialized = true

    let socket = getSocket()

    serverFileExplorerChannel = socket.channel("file_explorer:channel", {})

    serverFileExplorerChannel.join()
      .receive("ok", resp => { console.log("ServerFileExplorerChannel joined successfully.") })
      .receive("error", resp => { console.log("Unable to join ServerFileExplorerChannel.") })
      .receive("timeout", resp => { console.log("Unable to join ServerFileExplorerChannel.") })
  }

  return serverFileExplorerChannel
}

export default getServerFileExplorerChannel
