<template>
  <div>
    <template v-for="component in internalComponents">
      <textarea-selector
        v-if="component.tag === 'textarea-selector'"
        :resource="component.resource"
        v-model="model[component.model]"
        :disabled="disabled">
      </textarea-selector>
      <text-selector
        v-if="component.tag === 'text-selector'"
        :resource="component.resource"
        v-model="model[component.model]"
        :disabled="disabled">
      </text-selector>
      <server-file-selector
        v-if="component.tag === 'server-file-selector'"
        :resource="component.resource"
        :default-path="component.defaultPath"
        v-model="model[component.model]"
        :disabled="disabled">
      </server-file-selector>
      <optional-selector
        v-if="component.tag === 'optional-selector'"
        :resource="component.resource"
        :description="component.description"
        :components="component.components"
        :selected="component.selected"
        v-model="model[component.model]"
        :disabled="disabled">
      </optional-selector>
    </template>
  </div>
</template>

<script>
  import { reactive, watch } from "@vue/composition-api"
  import serverFileSelector from "./server-file-selector"
  import textSelector from "./text-selector"
  import textareaSelector from "./textarea-selector"
  import optionalSelector from "./optional-selector"
  import  { getComponentLiterals } from "./utilities"

  export default {
    name: "components-selector",
    components: {
      "server-file-selector": serverFileSelector,
      "text-selector": textSelector,
      "textarea-selector": textareaSelector,
      "optional-selector": optionalSelector
    },
    props: {
      components: Array,
      valuesUpdate: {
        type: Array,
        default: function () {
          return []
        }
      },
      disabled: {
        type: Boolean,
        default: false
      },
    },
    setup(props, context) {
      // Tags which require object values
      let objectTags = ["optional-selector"]

      // 'components' serve as template for 'keys'
      const keys = reactive(getKeyList(props.components, objectTags))

      // 'components' is expected not to change
      // Keep internal copy of original 'components'
      const internalComponents = reactive(duplicateComponents(props.components, keys))

      // 'model' is built based on 'keys' specifications
      const model = reactive(makeModel(keys))

      // 'model' should match 'value' if 'value' has all matching keys
      watch(
        () => props.value,
        (value) => {
          if (validateObject(value, keys)) {
            valueCopy(model, value, keys)
          } else {
            context.emit('input', reactive(copyModel(model, keys)))
          }
        },
        { deep: true }
      )

      // Emit to parent when 'model' is changed
      watch(
        () => model,
        (model) => {
          context.emit('input', reactive(copyModel(model, keys)))
        },
        { deep: true }
      )

      return {
        keys,
        internalComponents,
        model
      }
    }
  }
</script>
