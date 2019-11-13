<!--
  'tooltip-text-flex-button' is a wrapper around 'text-flex-button' to
  add tooltip functionality using `b-tooltip`.
-->

<template>
  <div ref="containerRef" :class="containerClass">
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
      :target="containerRef"
      :title="title"
      :disabled.sync="model.tooltipDisabled">
    </b-tooltip>
  </div>
</template>

<script>
  import Vue from "vue"
  import { reactive, ref, watch } from "@vue/composition-api"
  import textFlexButton from "./text-flex-button"

  export default {
    inheritAttrs: false,
    props: {
      containerClass: {
        type: String,
        default: ""
      },
      buttonClass: {
        type: String,
        default: ""
      },
      buttonStyle: {
        type: String,
        default: ""
      },
      html: {
        type: String,
        default: ""
      },
      title: {
        type: String,
        default: ""
      },
    }
    components: {
      "text-flex-button": textFlexButton
    },
    setup(props, context) {
      // Define container reference.
      const containerRef = ref(null)

      // Component's internal data.
      const model = reactive({
        tooltipDisabled: true,
        tooltipMounted: false
      })

      // When the title changes, need to reinitialize the tooltip.
      watch(
        () => props.title,
        (title) => {
          model.tooltipMounted = false

          Vue.nextTick(() => {
            model.tooltipMounted = true
          })
        }
      )

      // `model.tooltipDisabled` should be disabled when `object.selector` is
      // not "HTML"
      function handleSelector(object) {
        model.tooltipDisabled = object.selector === "HTML"
      }

      return {
        containerRef,
        model,
        handleSelector
      }
    }
  }
</script>
