<template>
  <div class="container-fluid">
    <div class="row">
      <div class="col">
        <h1 class="text-center">PrintClient</h1>
          <div class="row">
            <div class="col">
              <server-file-text-requester
                resource="PrintClient Configurations"
                default-path="print_client_configurations/"
                value="print_client_configurations/test.json"
                @selection-update="handleSelectionUpdate">
              </server-file-text-requester>
              <template v-if="components !== null">
                <printer-connection @connection-update="updatePrintClientChannel" @control-update="updateControlStatus"></printer-connection>
                <client-components :components="components" v-model="model" :disabled="!active"></client-components>
              </template>
            </div>
            <!-- <template v-if="components !== null">
              <div class="col-3">
                <display-users :print-client-channel="printClientChannel"></display-users>
              </div>
            </template> -->
          </div>
      </div>
      <div class="col-4">
        <request-manager :current-job="model" @load-job="handleLoadJob"></request-manager>
      </div>
    </div>
  </div>
</template>

<script>
  import Vue from "vue"
  import { reactive, ref, computed, watch } from "@vue/composition-api"
  import serverFileTextRequester from "./print-client/server-file-text-requester"
  import printerConnection from "./print-client/printer-connection"
  import displayUsers from "./print-client/display-users"
  import requestManager from "./print-client/request-manager"
  import clientComponents from "./print-client/client-components"

  export default {
    components: {
      "server-file-text-requester" : serverFileTextRequester,
      "printer-connection": printerConnection,
      "display-users": displayUsers,
      "request-manager": requestManager,
      "client-components": clientComponents
    },
    setup(props, context) {
      const model = reactive({})
      const components = ref(null)
      const badPrintClientConfigurationFile = ref(false)
      const clientHasControl = ref(false)
      const printClientChannel = ref(null)

      const active = computed(() => {
        return ((printClientChannel.value === null) || clientHasControl.value)
      })

      function handleSelectionUpdate(obj) {
        if (obj.text === "") {
          components.value = null
          // model.value = {}
          badPrintClientConfigurationFile.value = (obj.path !== "")
        } else {
          try {
            let tempComponents = JSON.parse(obj.text).components

            // let tempModel = {}
            // for (let i = 0; i < tempComponents.length; i++) {
            //   tempModel[tempCompoents[i].model] = ""
            // }

            components.value = null
            // model.value = {}
            badPrintClientConfigurationFile.value = false
            console.log("test")
            Vue.nextTick(() => {
              console.log("test1")
              components.value = tempComponents
              // model.value = tempModel
            })
          } catch (e) {
            components.value = null
            // model.value = {}
            badPrintClientConfigurationFile.value = true
          }
        }
      }

      function updatePrintClientChannel(obj) {
        if (obj.event == "connected") {
          printClientChannel.value = obj.printClientChannel
        } else {
          printClientChannel.value = null
        }
      }

      function updateControlStatus(obj) {
        if (obj.event == "control") {
          clientHasControl.value = obj.hasControl
        }
      }

      function handleLoadJob(obj) {
        if (active && (components !== null)) {
          for (let attr in obj.job) {
            model.value[attr] = obj.job[attr]
          }
        }
      }

      return {
        model,
        components,
        badPrintClientConfigurationFile,
        clientHasControl,
        printClientChannel,
        active,
        handleSelectionUpdate,
        updatePrintClientChannel,
        updateControlStatus,
        handleLoadJob
      }
    }
  }
</script>
