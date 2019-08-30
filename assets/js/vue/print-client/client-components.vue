<template>
  <div>
    <template v-for="component in components">
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
    </template>
  </div>
</template>

<script>
  import { reactive, watch } from "@vue/composition-api"
  import serverFileSelector from "./server-file-selector"
  import textSelector from "./text-selector"
  import textareaSelector from "./textarea-selector"

  export default {
    components: {
      "server-file-selector": serverFileSelector,
      "text-selector": textSelector,
      "textarea-selector": textareaSelector
    },
    props: {
      components: Array,
      value: {
        Object,
        default: function () {
          return {}
        }
      },
      disabled: {
        type: Boolean,
        default: false
      },
    },
    setup(props, context) {
      // 'components.model' serve as keys for 'model'
      let tempModel = {}
      for (let i = 0; i < props.components.length; i++) {
        tempModel[props.components[i].model] = ""
      }
      const model = reactive(tempModel)

      // Collect keys into 'keys'
      let keys = Object.keys(tempModel).sort()

      // Returns a new object with the same key/values as 'model'
      function duplicate() {
        let obj = {}

        for (let i = 0; i < keys.length; i++) {
          obj[keys[i]] = model[keys[i]]
        }

        return obj
      }

      // 'model' should match 'value' if 'value' has all matching keys
      watch(
        () => props.value,
        (value) => {
          let valueKeysString = JSON.stringify(Object.keys(value).sort())
          let keysString = JSON.stringify(keys)
          if (valueKeysString === keysString) {
            for (let i = 0; i < keys.length; i++) {
                if (model[keys[i]] !== value[keys[i]]) {
                  model[keys[i]] = value[keys[i]]
                }
            }
          } else {
            context.emit('input', duplicate())
          }
        },
        { deep: true }
      )

      // Emit to parent when 'model' is changed
      watch(
        () => model,
        (model) => {
          context.emit('input', duplicate())
        },
        { deep: true }
      )

      return {
        model
      }
    }
  }
</script>
