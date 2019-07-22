import getSocket from "./get-socket"

let isInitialized = false
let serverPrintClientConfigurationStoreChannel = null

function getServerPrintClientConfigurationStoreChannel() {
  if (!isInitialized) {
    isInitialized = true

    let socket = getSocket()

    serverPrintClientConfigurationStoreChannel = socket.channel("print_client_configuration_store:channel", {})

    serverPrintClientConfigurationStoreChannel.join()
      .receive("ok", resp => { console.log("ServerPrintClientConfigurationStoreChannel joined successfully.") })
      .receive("error", resp => { console.log("Unable to join ServerPrintClientConfigurationStoreChannel.") })
      .receive("timeout", resp => { console.log("Unable to join ServerPrintClientConfigurationStoreChannel.") })
  }

  return serverPrintClientConfigurationStoreChannel
}

export default getServerPrintClientConfigurationStoreChannel
