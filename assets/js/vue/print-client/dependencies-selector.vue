<template>
  <div>
    <server-path-selector
      :type="components.dependenciesTarget.type"
      :resource="components.dependenciesTarget.resource"
      :default-path="components.dependenciesTarget.defaultPath"
      :value="components.dependenciesTarget.value"
      @input="handleValueInput($event)"
      :disabled="disabled">
    </server-path-selector>
    <div class="ml-4">
      <components-selector
        :components="components"
        @component-update="handleForwardComponentUpdate($event)"
        :disabled="disabled">
      </components-selector>
    </div>
  </div>
</template>

<script>
  import serverPathSelector from "./server-path-selector"

  export default {
    components: {
      "components-selector": () => import("./components-selector"),
      "server-path-selector": serverPathSelector
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
      }
    },
    setup(props, context) {
      console.log(props.components)




      //  Constructs payload object:
      //    - 'object.path' is an array containing indices to target.
      //    - 'object.value' is value of target.
      //  Emits event "component-update" with payload object.
      function handleValueInput(value) {
        let path = ["dependenciesTarget"]
        context.emit("component-update", {path: path, value: value})
      }

      //  'dependencies-selector' does not need to modify payload. Emits event
      //  "component-update" with payload object.
      function handleForwardComponentUpdate(object) {
        context.emit("component-update", object)
      }

      return {
        handleValueInput,
        handleForwardComponentUpdate
      }
    }
  }
</script>
