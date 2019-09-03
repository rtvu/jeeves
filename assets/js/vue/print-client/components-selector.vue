<template>
  <div>
    <template v-for="component in componentsModel">
      <textarea-selector
        v-if="component.tag === 'textarea-selector'"
        :resource="component.resource"
        :value="component.value"
        @input="handleValueInput([component.model], $event)"
        :disabled="disabled">
      </textarea-selector>
      <text-selector
        v-if="component.tag === 'text-selector'"
        :resource="component.resource"
        :value="component.value"
        @input="handleValueInput([component.model], $event)"
        :disabled="disabled">
      </text-selector>
      <server-file-selector
        v-if="component.tag === 'server-file-selector'"
        :resource="component.resource"
        :default-path="component.defaultPath"
        :value="component.value"
        @input="handleValueInput([component.model], $event)"
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
  import { reactive, watch } from "@vue/composition-api"
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
      // Tags which have value properties
      let valueTags = getValueTags()

      // Model
      const componentsModel = reactive(duplicateItem(props.components))

      function handleValueInput(path, value) {
        for (let i = 0; i < componentsModel.length; i++) {
          if (path[0] === componentsModel[i].model) {
            componentsModel[i].value = value
            context.emit('input', {path: path, value: value})
          }
        }
      }









      //
      //
      // // 'model' should match 'value' if 'value' has all matching keys
      // watch(
      //   () => props.value,
      //   (value) => {
      //     if (validateObject(value, keys)) {
      //       valueCopy(model, value, keys)
      //     } else {
      //       context.emit('input', reactive(copyModel(model, keys)))
      //     }
      //   },
      //   { deep: true }
      // )
      //
      // // Emit to parent when 'model' is changed
      // watch(
      //   () => model,
      //   (model) => {
      //     context.emit('input', reactive(copyModel(model, keys)))
      //   },
      //   { deep: true }
      // )

      return {
        componentsModel,
        handleValueInput
      }
    }
  }
</script>
