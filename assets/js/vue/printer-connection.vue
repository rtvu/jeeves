<template>
    <form>
      <div class="row my-1">
        <div class="col-2">
          <button type="button" :class="connectButtonClass" @click="clickConnectButton">{{ connectButtonTitle }}</button>
        </div>
        <div class="col">
          <input type="text" class="form-control form-control-sm" :readonly="inputState" v-model="printer">
        </div>
        <div class="col-2">
          <button type="button" :class="controlButtonClass" :disabled="controlButtonState" @click="clickControlButton">{{ controlButtonTitle }}</button>
        </div>
        <div>
          {{ printer }}
        </div>
      </div>
    </form>
</template>

<script>
  export default {
    props: {
    },
    data () {
      return {
        connected: false,
        control: false,
        printer: ""
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
        this.connected = !this.connected
      },
      clickControlButton () {
        this.control = !this.control
      }
    }
  }
</script>
