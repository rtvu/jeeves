<template>
  <div>
    <div class="row my-2">
      <div class="col">
        <div class="input-group">
          <tooltip-text-flex-button
            div-class="input-group-prepend w-10"
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
    <div class="row">
      <!-- <div class="col">
        <hr class="float-right m-0 w-90" style="border-top: dashed 2px;" />
      </div> -->
      <div class="col ml-4">
        <hr class="text-secondary m-0" style="border-top: dashed 2px;" />
      </div>
    </div>
    <div class="row" v-if="components.optionalSelector.value">
      <div class="col ml-4">
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
