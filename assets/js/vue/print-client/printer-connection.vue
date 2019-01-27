<template>
  <form>
    <div class="row my-1">
      <div class="col-2">
        <tooltip-text-flex-button
          :button-class="connectionButtonClass"
          button-style=""

          :html="connectionButtonText"
          :title="connectionButtonText"

          @click="clickConnectionButton">
        </tooltip-text-flex-button>
      </div>

      <div class="col">
        <input
          type="text"
          class="form-control form-control-sm"

          :readonly="isInputInactive"
          v-model="printerID"
          @keypress.enter.prevent>
      </div>

      <div class="col-2">
        <tooltip-text-flex-button
          :button-class="controlButtonClass"
          button-style=""

          :html="controlButtonText"
          :title="controlButtonText"

          :disabled="isControlButtonDisabled"
          @click="clickControlButton">
        </tooltip-text-flex-button>
      </div>
    </div>
  </form>
</template>

<script>
  import getSocket from "../../get-socket"
  import clientID from "../../client-id"
  import tooltipTextFlexButton from "../utilities/tooltip-text-flex-button"
  import $ from "jquery"

  export default {
    components: {
      "tooltip-text-flex-button": tooltipTextFlexButton
    },
    data () {
      return {
        isConnected: false,
        hasControl: false,
        printerID: "",
        printClientChannel: null
      }
    },
    computed: {
      connectionButtonText () {
        return this.isConnected ? "Disconnect" : "Connect"
      },
      connectionButtonClass () {
        return this.isConnected ? ["btn", "btn-sm", "btn-block", "btn-danger"] : ["btn", "btn-sm", "btn-block", "btn-success"]
      },
      isInputInactive () {
        return this.isConnected
      },
      controlButtonText () {
        return this.hasControl ? "Drop Control" : "Take Control"
      },
      controlButtonClass () {
        return this.hasControl ? ["btn", "btn-sm", "btn-block", "btn-warning"] : ["btn", "btn-sm", "btn-block", "btn-danger"]
      },
      isControlButtonDisabled () {
        return !this.isConnected
      }
    },
    methods: {
      clickConnectionButton () {
        if (this.printerID != "") {
          if (!this.isConnected) {
            let socket = getSocket()
            this.printClientChannel = socket.channel(`print_client:${this.printerID}`, {})

            this.printClientChannel.join()
              .receive("ok", () => {
                console.log("PrintClientChannel joined successfully.")
                this.isConnected = true
                this.$emit("connection-update", {event: "connected", printClientChannel: this.printClientChannel})
              })
              .receive("error", () => {
                console.log("Unable to join PrintClientChannel.")
                this.printClientChannel = null
              })
              .receive("timeout", () => {
                console.log("Unable to join PrintClientChannel.")
                this.printClientChannel = null
              })

            this.printClientChannel.on("control:controlling_client_id", message => {
              this.hasControl = clientID == message.controlling_client_id
            })
          } else {
            this.printClientChannel.push("control:drop", {})
            this.hasControl = false

            this.printClientChannel.leave()
              .receive("ok", () => {
                console.log("PrintClientChannel left successfully.")
                this.isConnected = false
                this.printClientChannel = null
                this.$emit("connection-update", {event: "disconnected"})
              })
              .receive("error", () => { console.log("Unable to leave PrintClientChannel.") })
              .receive("timeout", () => { console.log("Unable to leave PrintClientChannel.") })
          }
        }
      },
      clickControlButton () {
        if (this.hasControl) {
          this.printClientChannel.push("control:drop", {})
        } else {
          this.printClientChannel.push("control:take", {})
        }
      }
    }
  }
</script>
