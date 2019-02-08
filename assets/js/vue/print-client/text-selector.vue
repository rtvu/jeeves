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
        <input
          type="text"
          class="form-control form-control-sm"

          :value="value"
          @input="$emit('input', $event.target.value)"

          v-bind="$attrs"
          v-on="listeners">
      </div>
    </div>
  </form>
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
