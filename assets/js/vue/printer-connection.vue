<template>
  <form>
    <div class="row my-1">
      <div class="col-2">
        <text-flex-button
          class="small"

          v-b-tooltip.hover
          :title="connectButtonTitle"
          :text="connectButtonTitle"
          :class="connectButtonClass"
          @click="clickConnectButton">
        </text-flex-button>
      </div>
      <div class="col">
        <input
          type="text"
          class="form-control form-control-sm"

          :readonly="inputState"
          v-model="printer"
          @keypress.enter.prevent>
      </div>
      <div class="col-2">
        <text-flex-button
          class="small"

          v-b-tooltip.hover
          :title="controlButtonTitle"
          :text="controlButtonTitle"
          :class="controlButtonClass"
          :disabled="controlButtonState"
          @click="clickControlButton">
        </text-flex-button>
      </div>
    </div>
  </form>
</template>

<script>
  import socket from "../socket"
  import clientID from "../client-id"
  import textFlexButton from "./utilities/text-flex-button"
  import $ from "jquery"

  export default {
    props: {
    },
    components: {
      "text-flex-button": textFlexButton
    },
    data () {
      return {
        windowWidth: 0,
        controlTextFit: true,
        connected: false,
        control: false,
        printer: "",
        printClientChannel: null
      }
    },
    watch: {
      windowWidth (newWidth, oldWidth) {
        this.controlTextFit = $(this.$refs.controlButton).width() > $(this.$refs.controlDiv).width()
      },
      // connectTextFit (newFit, oldFit) {
      //   if (newFit) {
      //     this.$refs.connectDiv.style.visibility = "visible"
      //   } else {
      //     this.$refs.connectDiv.style.visibility = "hidden"
      //   }
      // },
      // controlTextFit (newFit, oldFit) {
      //   if (newFit) {
      //     this.$refs.controlDiv.style.visibility = "visible"
      //   } else {
      //     this.$refs.controlDiv.style.visibility = "hidden"
      //   }
      // }
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
    mounted () {
      this.controlTextFit = $(this.$refs.controlButton).width() > $(this.$refs.controlDiv).width()
      this.$nextTick(() => {
        window.addEventListener("resize", () => {
          this.windowWidth = window.innerWidth
        })
      })
    },
    beforeDestroy () {
      window.removeEventListener("resize", () => {
        this.windowWidth = window.innerWidth
      })
    },
    methods: {
      clickConnectButton () {
        if (this.printer != "") {
          // this.connected = !this.connected
          if (!this.connected) {
            this.printClientChannel = socket.channel(`print_client:${this.printer}`, {})

            this.printClientChannel.join()
              .receive("ok", () => {
                console.log("PrintClientChannel joined successfully.")
                this.connected = true
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
                this.connected = false
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
