<template>
  <div class="row my-2">
    <div class="col">
      <selector-group>
        <template #selector-prepend>
          <tooltip-text-flex-button
            div-class="w-100"
            button-class="btn btn-sm btn-outline-dark btn-block"
            button-style="border-top-right-radius: 0; border-bottom-right-radius: 0;"

            disabled

            :html="resource"
            :title="resource">
          </tooltip-text-flex-button>
        </template>
        <template #selector>
          <input
            type="text"
            class="form-control form-control-sm"

            :value="value"

            v-bind="$attrs"
            v-on="listeners">
        </template>
      </selector-group>
    </div>
  </div>
</template>

<script>
  import { computed } from "@vue/composition-api"
  import tooltipTextFlexButton from "../utilities/tooltip-text-flex-button"
  import selectorGroup from "../utilities/selector-group"

  export default {
    inheritAttrs: false,
    props: {
      resource: String,
      value: String
    },
    components: {
      "tooltip-text-flex-button": tooltipTextFlexButton,
      "selector-group": selectorGroup
    },
    setup(props, context) {
      const listeners = computed(() => {
        return Object.assign({}, context.parent.$listeners, {
          input: (event) => {
            context.emit("input", event.target.value)
          }
        })
      })

      return {
        listeners
      }
    }
  }
</script>
