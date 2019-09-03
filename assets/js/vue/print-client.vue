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
                value="print_client_configurations/blah.json"
                @selection-update="handleSelectionUpdate">
              </server-file-text-requester>
              <template v-if="componentsModel !== null">
                <printer-connection
                  @connection-update="updatePrintClientChannel"
                  @control-update="updateControlStatus">
                </printer-connection>
                <components-selector
                  :components="componentsModel.components"
                  @input="handleComponentInput($event)"
                  :disabled="!active">
                </components-selector>
              </template>
            </div>
            <!-- <template v-if="components !== null">
              <div class="col-3">
                <display-users :print-client-channel="printClientChannel"></display-users>
              </div>
            </template> -->
          </div>
      </div>
      <!-- <div class="col-4">
        <request-manager :current-job="model" @load-job="handleLoadJob"></request-manager>
      </div> -->
    </div>
    {{ componentsModel }}
  </div>
</template>

<script>
  import Vue from "vue"
  import { ref, computed, watch } from "@vue/composition-api"
  import serverFileTextRequester from "./print-client/server-file-text-requester"
  import printerConnection from "./print-client/printer-connection"
  import displayUsers from "./print-client/display-users"
  import requestManager from "./print-client/request-manager"
  import componentsSelector from "./print-client/components-selector"
  import { addValueProperty, setNestedComponentProperty } from "./print-client/components-utilities"

  export default {
    components: {
      "server-file-text-requester" : serverFileTextRequester,
      "printer-connection": printerConnection,
      "display-users": displayUsers,
      "request-manager": requestManager,
      "components-selector": componentsSelector
    },
    setup(props, context) {
      const componentsModel = ref(null)
      const clientHasControl = ref(false)
      const printClientChannel = ref(null)

      const active = computed(() => {
        return ((printClientChannel.value === null) || clientHasControl.value)
      })

      function handleSelectionUpdate(obj) {
        componentsModel.value = null

        if (obj.text !== "") {
          try {
            let temp = JSON.parse(obj.text)
            let tempComponentsModel = temp.rootComponent
            addValueProperty([tempComponentsModel])

            Vue.nextTick(() => {
              componentsModel.value = tempComponentsModel
            })
          } catch (e) {
            console.log("Could not parse file.")
          }
        }
      }

      function updatePrintClientChannel(obj) {
        if (obj.event === "connected") {
          printClientChannel.value = obj.printClientChannel
        } else {
          printClientChannel.value = null
        }
      }

      function updateControlStatus(obj) {
        if (obj.event === "control") {
          clientHasControl.value = obj.hasControl
        }
      }

      // function handleLoadJob(obj) {
      //   if (active && (components !== null)) {
      //     for (let attr in obj.job) {
      //       model[attr] = obj.job[attr]
      //     }
      //   }
      // }

      // watch(
      //   () => model,
      //   (model) => {
      //     console.log("hello")
      //   },
      //   { deep: true}
      // )

      function handleComponentInput(event) {
        setNestedComponentProperty(componentsModel.value.components, event.path, event.value)
      }

      return {
        componentsModel,
        clientHasControl,
        printClientChannel,
        active,
        handleSelectionUpdate,
        updatePrintClientChannel,
        updateControlStatus,
        handleComponentInput
        // handleLoadJob,
      }
    }
  }
</script>
