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
      <!-- <optional-selector
        v-if="component.tag === 'optional-selector'"
        :resource="component.resource"
        :description="component.description"
        :components="component.components"
        :selected="component.selected"
        v-model="model[component.model]"
        :disabled="disabled">
      </optional-selector> -->
    </template>
  </div>
</template>

<script>
  import Vue from "vue"
  import { ref, reactive, watch } from "@vue/composition-api"
  import serverFileSelector from "./server-file-selector"
  import textSelector from "./text-selector"
  import textareaSelector from "./textarea-selector"
  // import optionalSelector from "./optional-selector"
  import  { getValueTags, duplicateItem } from "./components-utilities"

  export default {
    name: "components-selector",
    components: {
      "server-file-selector": serverFileSelector,
      "text-selector": textSelector,
      "textarea-selector": textareaSelector,
      // "optional-selector": optionalSelector
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






      return {
        componentsIndex,
        handleValueInput
      }
    }
  }
</script>
