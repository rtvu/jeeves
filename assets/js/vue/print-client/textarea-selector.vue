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
        <resizable-textarea
          class="form-control form-control-sm"

          :value="value"

          v-bind="$attrs"
          v-on="$listeners">
        </resizable-textarea>
      </div>
    </div>
  </div>
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
