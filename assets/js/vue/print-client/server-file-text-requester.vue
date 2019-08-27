<template>
    <!-- <server-file-selector
      :resource="resource"
      :default-path="defaultPath"

      :value="value"
      @input="$emit('input', $event)"
      v-model="path"
      :disabled="disabled">
    </server-file-selector> -->
    <server-file-selector
      :resource="resource"
      :default-path="defaultPath"

      :value="value"
      @input="handleInput($event)"

      :disabled="disabled">
    </server-file-selector>
</template>

<script>
  import { ref, onCreated, watch } from "@vue/composition-api"
  import getServerFileExplorerChannel from "../../get-server-file-explorer-channel"
  import serverFileSelector from "./server-file-selector"

  export default {
    props: {
      resource: String,
      defaultPath: String,
      value: {
        type: String,
        default: ""
      },
      disabled: {
        type: Boolean,
        default: false
      },
    },
    components: {
      "server-file-selector": serverFileSelector,
    },
    setup(props, context) {
      const path = ref("")

      let serverFileExplorerChannel = null
      onCreated(() => {
        serverFileExplorerChannel = getServerFileExplorerChannel()
      })

      function handleInput(event) {
        context.emit('input', event)
        path.value = event
      }

      watch(() => {
        if (path.value == "") {
          context.emit("selection-update", {path: "", text: ""})
        } else {
          serverFileExplorerChannel.push("send-file-as-text", { path: path.value })
            .receive("ok", resp => {
              context.emit("selection-update", {path: path.value, text: resp.body})
            })
            .receive("failed", () => {
              context.emit("selection-update", {path: path.value, text: ""})
            })
        }
      })

      return {
        path,
        handleInput
      }
    }
  }
</script>
