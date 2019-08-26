<template>
  <div>
    <server-file-selector
      resource="PrintClient Configurations"
      default-path="print_client_configurations/"
      v-model="path">
    </server-file-selector>
    <p>Path: {{ path }}</p>
    <p>Configuration: {{ configuration }}</p>
  </div>
</template>

<script>
  import { ref, reactive, onCreated, watch } from "@vue/composition-api"
  import getServerFileExplorerChannel from "../../get-server-file-explorer-channel"
  import serverFileSelector from "./server-file-selector"

  export default {
    props: {
      resource: String,
      value: String
    },
    components: {
      "server-file-selector": serverFileSelector,
    },
    setup(props, context) {
      const path = ref("")
      const configuration = ref(null)

      let serverFileExplorerChannel = null
      onCreated(() => {
        serverFileExplorerChannel = getServerFileExplorerChannel()
      })

      watch(() => {
        if (path.value == "") {
          configuration.value = null
          context.emit("hello", "")
        } else {
          serverFileExplorerChannel.push("get-json-contents", { path: path.value })
            .receive("ok", resp => {
              configuration.value = resp
          })
          context.emit("hello", "")
        }
      })


      return {
        path,
        configuration
      }
    }
  }
</script>
