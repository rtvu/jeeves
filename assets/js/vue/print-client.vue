<template>
  <div class="container-fluid">
    <div class="row">
      <div class="col">
        <h1 class="text-center">PrintClient</h1>
          <div class="row">
            <div class="col">
              <printer-connection @connection-update="updatePrintClientChannel"></printer-connection>
              <template v-for="component in components">
                <textarea-selector
                  v-if="component.tag === 'textarea-selector'"
                  :resource="component.resource"
                  v-model="model[component.model]">
                </textarea-selector>
                <text-selector
                  v-if="component.tag === 'text-selector'"
                  :resource="component.resource"
                  v-model="model[component.model]">
                </text-selector>
                <server-file-selector
                  v-if="component.tag === 'server-file-selector'"
                  :resource="component.resource"
                  :default-path="component.defaultPath"
                  v-model="model[component.model]">
                </server-file-selector>
              </template>
            </div>
            <div class="col-3">
              <display-users :print-client-channel="printClientChannel"></display-users>
            </div>
          </div>

        <p>Description: {{ model.description }}</p>
        <p>Comments: {{ model.comments }}</p>
        <p>Settings: {{ model.settings }}</p>
        <p>Configuration: {{ model.configuration }}</p>
      </div>
      <div class="col-4">
        <request-manager :current-job="model"></request-manager>
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
    props: ["components"],
    data () {
      let model = {}
      for (let i = 0; i < this.components.length; i++) {
        model[this.components[i].model] = ""
      }

      return {
        model: model,
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
