<template>
  <div class="row my-2">
    <div class="col">
      <selector-group>
        <template #selector-prepend>
          <tooltip-text-flex-button
            container-class="w-100"
            button-class="btn btn-sm btn-outline-dark btn-block"
            button-style="border-top-right-radius: 0; border-bottom-right-radius: 0;"

            disabled

            :html="resource"
            :title="resource">
          </tooltip-text-flex-button>
        </template>
        <template #selector>
          <resizable-textarea
            class="form-control form-control-sm"

            :value="value"

            v-bind="$attrs"
            v-on="$listeners">
          </resizable-textarea>
        </template>
      </selector-group>
    </div>
  </div>
</template>

<script>
  import tooltipTextFlexButton from "../utilities/tooltip-text-flex-button"
  import resizableTextarea from "../utilities/resizable-textarea"
  import selectorGroup from "../utilities/selector-group"

  export default {
    inheritAttrs: false,
    props: {
      resource: String,
      value: String
    },
    components: {
      "tooltip-text-flex-button": tooltipTextFlexButton,
      "resizable-textarea": resizableTextarea,
      "selector-group": selectorGroup
    },
    setup(props, context) {
      return {}
    }
  }
</script>
