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
          <input type="text" class="form-control form-control-sm" readonly :value="description">
        </div>
      </div>
    </div>
    <div class="row my-1" v-if="isSelected">
      <div class="col ml-3">
        <client-components :components="components" :value="model" @input="handleInput($event)" :disabled="disabled"></client-components>
      </div>
    </div>
  </div>
</template>

<script>
  import Vue from "vue"
  import { reactive, ref, watch } from "@vue/composition-api"
  import tooltipTextFlexButton from "../utilities/tooltip-text-flex-button"

  export default {
    components: {
      "tooltip-text-flex-button": tooltipTextFlexButton,
      "client-components": () => import("./client-components")
    },
    props: {
      resource: String,
      description: String,
      components: Array,
      value: Object,
      selected: {
        type: Boolean,
        default: false
      },
      disabled: {
        type: Boolean,
        default: false
      }
    },
    setup(props, context) {
      // 'isSelected' is internal copy of 'selected'
      const isSelected = ref(props.selected)

      // 'components.model' serve as keys for 'model'
      let tempModel = {}
      for (let i = 0; i < props.components.length; i++) {
        tempModel[props.components[i].model] = ""
      }
      const model = reactive(tempModel)

      // Collect keys into 'keys'
      let keys = Object.keys(tempModel)

      // Returns a new object with the same key/values as 'model'
      function duplicate() {
        let obj = {}

        for (let i = 0; i < keys.length; i++) {
          obj[keys[i]] = model[keys[i]]
        }

        return obj
      }

      // Clears 'model' values
      function clear() {
        for (let i = 0; i < keys.length; i++) {
          model[keys[i]] = ""
        }
      }

      // Handle input event
      function handleInput(event) {
        for (let i = 0; i < keys.length; i++) {
          model[keys[i]] = event[keys[i]]
        }
      }

      // Handle click event
      function handleClick() {
        isSelected.value = !isSelected.value

        if (!isSelected.value) {
          Vue.nextTick(() => {
            clear()
          })
        }
      }

      // Emit to parent when 'model' is changed
      watch(
        () => model,
        (model) => {
          context.emit('input', duplicate())
        },
        { deep: true }
      )

      return {
        isSelected,
        model,
        handleClick,
        handleInput
      }
    }
  }
</script>
