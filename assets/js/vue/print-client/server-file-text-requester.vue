<template>
    <server-path-selector
      type="files"

      :resource="resource"
      :default-path="defaultPath"

      :value="value"
      @input="handleInput($event)"

      :disabled="disabled">
    </server-path-selector>
</template>

<script>
  import { ref, watch } from "@vue/composition-api"
  import getServerFileExplorerChannel from "../../get-server-file-explorer-channel"
  import serverPathSelector from "./server-path-selector"

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
      "server-path-selector": serverPathSelector,
    },
    setup(props, context) {
      const path = ref(props.value)

      let serverFileExplorerChannel = getServerFileExplorerChannel()

      function handleInput(event) {
        path.value = event
      }

      watch(
        () => props.value,
        (value) => {
          if (path.value !== value) {
            path.value = value
          }
        },
        { lazy: true }
      )

      watch(
        path,
        (path) => {
          if (path == "") {
            context.emit("selection-update", {path: "", text: ""})
            context.emit('input', path)
          } else {
            serverFileExplorerChannel.push("send-file-as-text", { path: path })
              .receive("ok", resp => {
                context.emit("selection-update", {path: path, text: resp.body})
                context.emit('input', path)
              })
              .receive("failed", () => {
                context.emit("selection-update", {path: path, text: ""})
                context.emit('input', path)
              })
          }
        }
      )

      return {
        path,
        handleInput
      }
    }
  }
</script>
