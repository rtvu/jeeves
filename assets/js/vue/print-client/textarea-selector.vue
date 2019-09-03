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
        <resizable-textarea
          class="form-control form-control-sm"

          :value="value"

          v-bind="$attrs"
          v-on="$listeners">
        </resizable-textarea>
      </div>
    </div>
  </form>
</template>

<script>
  import tooltipTextFlexButton from "../utilities/tooltip-text-flex-button"
  import resizableTextarea from "../utilities/resizable-textarea"

  export default {
    inheritAttrs: false,
    props: {
      resource: String,
      value: String
    },
    components: {
      "tooltip-text-flex-button": tooltipTextFlexButton,
      "resizable-textarea": resizableTextarea
    },
    data () {
      return {}
    },
    computed: {
      listeners () {
        return Object.assign({}, this.$listeners, {
          input: () => {
            this.$emit('input', $event)
          }
        })
      }
    }
  }
</script>
