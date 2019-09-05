<template>
  <div>
    <template v-for="index in componentsIndex">
      <textarea-selector
        v-if="components[index].tag === 'textarea-selector'"
        :resource="components[index].resource"
        :value="components[index].value"
        @input="handleValueInput(index, $event)"
        :disabled="disabled">
      </textarea-selector>
      <text-selector
        v-if="components[index].tag === 'text-selector'"
        :resource="components[index].resource"
        :value="components[index].value"
        @input="handleValueInput(index, $event)"
        :disabled="disabled">
      </text-selector>
      <server-file-selector
        v-if="components[index].tag === 'server-file-selector'"
        :resource="components[index].resource"
        :default-path="components[index].defaultPath"
        :value="components[index].value"
        @input="handleValueInput(index, $event)"
        :disabled="disabled">
      </server-file-selector>
      <optional-selector
        v-if="components[index].tag === 'optional-selector'"
        :resource="components[index].resource"
        :description="components[index].description"
        :components="components[index].components"
        @component-update="handleComponentUpdate(index, $event)"
        :disabled="disabled">
      </optional-selector>
    </template>
  </div>
</template>

<script>
  import { ref, watch } from "@vue/composition-api"
  import optionalSelector from "./optional-selector"
  import serverFileSelector from "./server-file-selector"
  import textSelector from "./text-selector"
  import textareaSelector from "./textarea-selector"
  
  export default {
    name: "components-selector",
    components: {
      "optional-selector": optionalSelector,
      "server-file-selector": serverFileSelector,
      "text-selector": textSelector,
      "textarea-selector": textareaSelector
    },
    props: {
      components: {
        type: Object,
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
      const componentsIndex = ref([])
      watch(
        () => props.components.length,
        (length) => {
          componentsIndex.value = [ ...Array(length).keys() ]
        }
      )

      function handleValueInput(index, value) {
        context.emit('component-update', {path: [index], value: value})
      }

      function handleComponentUpdate(index, object) {
        object.path.unshift(index)
        context.emit('component-update', object)
      }

      return {
        componentsIndex,
        handleValueInput,
        handleComponentUpdate
      }
    }
  }
</script>
