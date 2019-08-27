<template>
  <!-- <div>
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
    <template v-for="component in components">
      <p>{{ component.resource }}: {{ model[component.model] }}</p>
    </template>
  </div> -->
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
    <template v-for="component in components">
      <p>{{ component.resource }}: {{ model[component.model] }}</p>
    </template>
  </div>
</template>

<script>
  import { reactive, ref, computed, watch } from "@vue/composition-api"
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
      disabled: Boolean
    },
    setup(props, context) {
      let temp = {}
      for (let i = 0; i < props.components.length; i++) {
        temp[props.components[i].model] = ""
      }

      const model = reactive(temp)

      return {
        model
      }
    }
  }
</script>
