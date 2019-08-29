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
      <!-- <textarea-selector
        v-if="component.tag === 'textarea-selector'"
        :resource="component.resource"

        :value="model[component.model]"
        @input="handleInput(component.model, $event)"

        :disabled="disabled">
      </textarea-selector>
      <text-selector
        v-if="component.tag === 'text-selector'"
        :resource="component.resource"

        :value="model[component.model]"
        @input="handleInput(component.model, $event)"

        :disabled="disabled">
      </text-selector>
      <server-file-selector
        v-if="component.tag === 'server-file-selector'"
        :resource="component.resource"
        :default-path="component.defaultPath"

        :value="model[component.model]"
        @input="handleInput(component.model, $event)"

        :disabled="disabled">
      </server-file-selector> -->
    </template>
    <template v-for="component in components">
      <p>{{ component.resource }}: {{ model[component.model] }}</p>
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
      value: Object,
      disabled: {
        type: Boolean,
        default: false
      },
    },
    setup(props, context) {
      let temp = {}
      for (let i = 0; i < props.components.length; i++) {
        temp[props.components[i].model] = ""
      }

      let keys = Object.keys(temp).sort()
      console.log(keys)

      const model = reactive(temp)

      watch(
        () => props.value,
        (value) => {
          let valueKeysString = JSON.stringify(Object.keys(value).sort())
          let keysString = JSON.stringify(keys)
          if (valueKeysString === keysString) {
            for (let i = 0; i < keys.length; i++) {
              model[keys[i]] = value[keys[i]]
            }
          }
        },
        { deep: true }
      )

      watch(
        () => props.value["description"],
        (value) => {
          console.log("description changed")
        }
      )

      // function handleInput(key, value) {
      //   model[key] = value
      // }

      return {
        model
      }
    }
  }
</script>
