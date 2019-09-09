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
      <server-path-selector
        v-if="components[index].tag === 'server-path-selector'"
        :type="components[index].type"
        :resource="components[index].resource"
        :default-path="components[index].defaultPath"
        :value="components[index].value"
        @input="handleValueInput(index, $event)"
        :disabled="disabled">
      </server-path-selector>
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
  import serverFileSelector from "./server-path-selector"
  import textSelector from "./text-selector"
  import textareaSelector from "./textarea-selector"

  export default {
    name: "components-selector",
    components: {
      "optional-selector": optionalSelector,
      "server-path-selector": serverFileSelector,
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
      //  Order is not guranteed when iterating through object keys.
      //
      //  'props.components' object contain numeric keys for children
      //  that are to be rendered. 'props.components' object also contain the
      //  key 'length' for the number of children components to be rendered.
      //
      //  'componentsIndex' is an array listing the numeric keys in
      //  'props.components'.
      const componentsIndex = ref([])
      watch(
        () => props.components.length,
        (length) => {
          //  [ ...Array(5).keys() ] --> [0, 1, 2, 3, 4]
          componentsIndex.value = [ ...Array(length).keys() ]
        }
      )

      //  Constructs payload object:
      //    - 'object.path' is an array containing indices to target.
      //    - 'object.value' is value of target.
      //  Emits event 'component-update' with payload object.
      function handleValueInput(index, value) {
        context.emit('component-update', {path: [index], value: value})
      }

      //  Payload object contains:
      //    - 'object.path' is an array containing indices to target.
      //    - 'object.value' is value of target.
      //  Updates 'object.path' with new index and then emits event
      //  'component-update' with updated payload object.
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
