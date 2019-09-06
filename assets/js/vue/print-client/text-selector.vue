<template>
  <div class="row my-2">
    <div class="col">
      <div class="input-group">
        <div class="input-group-prepend w-10">
          <tooltip-text-flex-button
            div-class="w-100"
            button-class="btn btn-sm btn-outline-dark btn-block"
            button-style="border-top-right-radius: 0; border-bottom-right-radius: 0;"

            disabled

            :html="resource"
            :title="resource">
          </tooltip-text-flex-button>
        </div>
        <input
          type="text"
          class="form-control form-control-sm"

          :value="value"

          v-bind="$attrs"
          v-on="listeners">
      </div>
    </div>
  </div>
</template>

<script>
  import tooltipTextFlexButton from "../utilities/tooltip-text-flex-button"

  export default {
    inheritAttrs: false,
    props: {
      resource: String,
      value: String
    },
    components: {
      "tooltip-text-flex-button": tooltipTextFlexButton
    },
    data () {
      return {}
    },
    computed: {
      listeners () {
        return Object.assign({}, this.$listeners, {
          input: () => {
            this.$emit("input", event.target.value)
          }
        })
      }
    }
  }
</script>
