<template>
    <form>
      <div class="row my-1">
        <div class="col-2">
          <button type="button" :class="connectButtonClass" @click="clickConnectButton">{{ connectButtonTitle }}</button>
        </div>
        <div class="col">
          <input type="text" class="form-control form-control-sm" :readonly="inputState" v-model="printer" @keypress.enter.prevent>
        </div>
        <div class="col-2">
          <button type="button" :class="controlButtonClass" :disabled="controlButtonState" @click="clickControlButton">{{ controlButtonTitle }}</button>
        </div>
      </div>
    </form>
</template>

<script>
  import socket from "../socket"
  import clientID from "../client-id"

  export default {
    props: {
    },
    data () {
      return {
        connected: false,
        control: false,
        printer: "",
        printClientChannel: null
      }
    },
    computed: {
      connectButtonTitle () {
        if (this.connected) {
          return "Disconnect"
        } else {
          return "Connect"
        }
      },
      connectButtonClass () {
        if (this.connected) {
          return ["btn", "btn-sm", "btn-block", "btn-danger"]
        } else {
          return ["btn", "btn-sm", "btn-block", "btn-success"]
        }
      },
      inputState () {
        if (this.connected) {
          return true
        } else {
          return false
        }
      },
      controlButtonTitle () {
        if (this.connected && this.control) {
          return "Release Control"
        } else {
          return "Take Control"
        }
      },
      controlButtonClass () {
        if (this.control) {
          return ["btn", "btn-sm", "btn-block", "btn-warning"]
        } else {
          return ["btn", "btn-sm", "btn-block", "btn-danger"]
        }
      },
      controlButtonState () {
        if (this.connected) {
          return false
        } else {
          return true
        }
      }
    },
    created () {
    },
    methods: {
      clickConnectButton () {
        if (this.printer != "") {
          this.connected = !this.connected
          if (this.connected) {
            this.printClientChannel = socket.channel(`print_client:${this.printer}`, {})

            this.printClientChannel.join()
              .receive("ok", () => {
                console.log("PrintClientChannel joined successfully.")
                this.$emit("connection-update", {event: "connected", printClientChannel: this.printClientChannel})
              })
              .receive("error", () => { console.log("Unable to join PrintClientChannel.") })

            this.printClientChannel.on("control:controlling_client_id", message => {
              if (clientID == message.controlling_client_id) {
                this.control = true
              } else {
                this.control = false
              }
            })
          } else {
            this.printClientChannel.leave()
              .receive("ok", () => {
                console.log("PrintClientChannel left successfully.")
                this.$emit("connection-update", {event: "disconnected"})
              })
              .receive("error", () => { console.log("Unable to leave PrintClientChannel.") })
          }
        }
      },
      clickControlButton () {
        if (this.control) {
          this.printClientChannel.push("control:release", {})
        } else {
          this.printClientChannel.push("control:take", {})
        }
      }
    }
  }
</script>
