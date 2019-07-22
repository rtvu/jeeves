<template>
  <form>
    <div class="row my-1">
      <div class="col-2">
        <tooltip-text-flex-button
          button-class="btn btn-sm btn-outline-dark btn-block"
          button-style=""

          disabled

          :html="resource"
          :title="resource">
        </tooltip-text-flex-button>
      </div>
      <div class="col">
        <v-select>
        </v-select>
      </div>
    </div>
  </form>
</template>

<script>
  import getServerPrintClientConfigurationStoreChannel from "../../get-server-print-client-configuration-store-channel"
  import tooltipTextFlexButton from "../utilities/tooltip-text-flex-button"
  import vSelect from "vue-select"

  export default {
    props: {
      resource: String,
      value: String
    },
    components: {
      "tooltip-text-flex-button": tooltipTextFlexButton,
      "v-select" : vSelect
    },
    data () {
      return {}
    },
    created () {
      this.serverFileExplorerChannel = getServerPrintClientConfigurationStoreChannel()
    },
  }
</script>
