<template>
  <div>
    <div class="row my-1">
      <div class="col">
        <div class="input-group">
          <tooltip-text-flex-button
            div-class="input-group-prepend w-20"
            button-class="btn btn-sm btn-secondary btn-block"
            button-style=""

            :html="resource"
            :title="resource"

            @click="handleClick">
          </tooltip-text-flex-button>
          <input
            type="text"
            class="form-control form-control-sm"
            readonly
            :value="description">
        </div>
      </div>
    </div>
    <div class="row my-1" v-if="components.optionalSelector.value">
      <div class="col ml-3">
        <components-selector
          :components="components"
          @component-update="handleComponentUpdate($event)"
          :disabled="disabled">
        </components-selector>
      </div>
    </div>
  </div>
</template>

<script>
  import tooltipTextFlexButton from "../utilities/tooltip-text-flex-button"

  export default {
    components: {
      "tooltip-text-flex-button": tooltipTextFlexButton,
      "components-selector": () => import("./components-selector")
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
      function handleClick() {
        let path = ["optionalSelector"]
        let value = !props.components.optionalSelector.value
        context.emit('component-update', {path: path, value: value})
      }

      function handleComponentUpdate(object) {
        context.emit('component-update', object)
      }

      return {
        handleClick,
        handleComponentUpdate
      }
    }
  }
</script>
