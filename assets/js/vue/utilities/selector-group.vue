<!--
  'selector-group' is an input group with a single prepend and single selector.
-->

<template>
  <div class="input-group" ref="containerRef">
    <div
      class="input-group-prepend"
      :class="model.widthClass"
      :style="model.widthStyle">
      <slot name="selector-prepend"></slot>
    </div>
    <slot name="selector"></slot>
  </div>
</template>

<script>
  import $ from "jquery"
  import Vue from "vue"
  import { onMounted, onBeforeUnmount, reactive, ref, watch } from "@vue/composition-api"

  export default {
    setup(props, context) {
      // Define template reference.
      const containerRef = ref(null)

      // Component's internal data.
      const model = reactive({
        windowWidth: -1,
        widthClass: "",
        widthStyle: ""
      })

      // Get window's inner width and set it to `model.windowWidth`.
      function getWindowWidth() {
        model.windowWidth = window.innerWidth
      }

      onMounted(() => {
        getWindowWidth()

        Vue.nextTick(() => {
          // Run `getWindowWidth` whenever window's resize event is triggered.
          window.addEventListener("resize", getWindowWidth)
        })

        // Window's width dictates the width of prepend.
        watch(
          () => model.windowWidth,
          (windowWidth) => {
            let containerWidth = $(containerRef.value).width()

            if (containerWidth < 350) {
              model.widthClass = "w-100"
              model.widthStyle = ""
            } else if (containerWidth < 725) {
              model.widthClass = ""
              model.widthStyle = "width: " + Math.floor(containerWidth * 0.3) + "px;"
            } else {
              model.widthClass = ""
              model.widthStyle = "width: 217px;"
            }
          }
        )
      })

      onBeforeUnmount(() => {
        // Remove trigger.
        window.removeEventListener("resize", getWindowWidth)
      })

      return {
        containerRef,
        model
      }
    }
  }
</script>
