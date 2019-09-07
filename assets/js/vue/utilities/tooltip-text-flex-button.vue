<template>
  <div ref="div" :class="divClass">
    <text-flex-button
      :class="buttonClass"
      :style="buttonStyle"

      :html="html"

      v-bind="$attrs"
      v-on="$listeners"
      @selector="handleSelector">
    </text-flex-button>
    <b-tooltip
      v-if="model.tooltipMounted"
      triggers="hover"
      :target="() => $refs.div"
      :title="title"
      :disabled.sync="model.tooltipDisabled">
    </b-tooltip>
  </div>
</template>

<script>
  import Vue from "vue"
  import { reactive, watch } from "@vue/composition-api"
  import textFlexButton from "./text-flex-button"

  export default {
    inheritAttrs: false,
    props: ["divClass", "buttonClass", "buttonStyle", "html", "title"],
    components: {
      "text-flex-button": textFlexButton
    },
    setup(props, context) {
      const model = reactive({
        tooltipDisabled: true,
        tooltipMounted: false
      })

      watch(
        () => props.title,
        (title) => {
          model.tooltipMounted = false

          Vue.nextTick(() => {
            model.tooltipMounted = true
          })
        }
      )

      function handleSelector(object) {
        model.tooltipDisabled = object.selector === "HTML"
      }

      return {
        model,
        handleSelector
      }
    }
  }
</script>
