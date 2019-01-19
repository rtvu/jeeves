<template>
  <div class="container">
    <div class="row">
      <div class="col">
        <h1 class="text-center">PrintClient</h1>
          <div class="row">
            <div class="col">
              <printer-connection @connection-update="updatePrintClientChannel"></printer-connection>
              <textarea-selector resource="Description" v-model="description"></textarea-selector>
              <textarea-selector resource="Comments" v-model="comments"></textarea-selector>
              <text-selector resource="Settings" v-model="settings"></text-selector>
              <server-file-selector resource="Image" default-path="images/c/g/" v-model="imageFile" :disabled="printClientDisabled"></server-file-selector>
              <!-- <server-file-selector resource="config" default-path="configs/" v-model="configFile" :disabled="printClientDisabled"></server-file-selector> -->
            </div>
            <div class="col-3">
              <display-users :print-client-channel="printClientChannel"></display-users>
            </div>
          </div>

        <p>Description: {{ description }}</p>
        <p>Comments: {{ comments }}</p>
        <p>Settings: {{ settings }}</p>
        <p>Image: {{ imageFile }}</p>
        <p>Config: {{ configFile }}</p>
      </div>
      <div class="col-4">
        <request-manager></request-manager>
      </div>
    </div>
  </div>
</template>

<script>
  import printerConnection from "./print-client/printer-connection"
  import serverFileSelector from "./print-client/server-file-selector"
  import displayUsers from "./print-client/display-users"
  import requestManager from "./print-client/request-manager"
  import textSelector from "./print-client/text-selector"
  import textareaSelector from "./print-client/textarea-selector"

  export default {
    components: {
      "printer-connection": printerConnection,
      "server-file-selector": serverFileSelector,
      "display-users": displayUsers,
      "request-manager": requestManager,
      "text-selector": textSelector,
      "textarea-selector": textareaSelector
    },
    data () {
      return {
        description: "",
        comments: "",
        settings: "",
        imageFile: "",
        configFile: "",
        printClientDisabled: false,
        printClientChannel: null
      }
    },
    methods: {
      updatePrintClientChannel (obj) {
        if (obj.event == "connected") {
          this.printClientChannel = obj.printClientChannel
        } else {
          this.printClientChannel = null
        }
      }
    }
  }
</script>
