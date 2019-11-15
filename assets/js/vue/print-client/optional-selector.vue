<template>
  <div>
    <div class="row my-2">
      <div class="col">
        <selector-group>
          <template #selector-prepend>
            <tooltip-text-flex-button
              container-class="w-100"
              button-class="btn btn-sm btn-secondary btn-block"
              button-style="border-top-right-radius: 0; border-bottom-right-radius: 0;"

              :html="resource"
              :title="resource"

              @click="handleClick">
            </tooltip-text-flex-button>
          </template>
          <template #selector>
            <input
              type="text"
              class="form-control form-control-sm"
              readonly
              :value="description">
          </template>
        </selector-group>
      </div>
    </div>
    <div class="row">
      <div class="col ml-4">
        <hr class="text-secondary m-0" style="border-top: dashed 2px;">
      </div>
    </div>
    <div class="row" v-if="components.optionalValue.value">
      <div class="col ml-4">
        <components-selector
          :components="components"
          @component-update="handleForwardComponentUpdate($event)"
          :disabled="disabled">
        </components-selector>
      </div>
    </div>
  </div>
</template>

<script>
  import tooltipTextFlexButton from "../utilities/tooltip-text-flex-button"
  import selectorGroup from "../utilities/selector-group"

  export default {
    components: {
      "tooltip-text-flex-button": tooltipTextFlexButton,
      "components-selector": () => import("./components-selector"),
      "selector-group": selectorGroup
    },
    props: {
      resource: String,
      description: String,
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
      //  Constructs payload object to set 'optional-value':
      //    - 'object.path' is an array containing indices to target.
      //    - 'object.value' is value of target.
      //  Emits event "component-update" with payload object.
      function handleClick() {
        let path = ["optionalValue"]
        let value = !props.components.optionalValue.value
        context.emit("component-update", {path: path, value: value})
      }

      //  'optional-selector' does not need to modify payload. Emits event
      //  "component-update" with payload object.
      function handleForwardComponentUpdate(object) {
        context.emit("component-update", object)
      }

      return {
        handleClick,
        handleForwardComponentUpdate
      }
    }
  }
</script>
