<template>
  <div class="input-group" ref="container">
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
  import { onMounted, onBeforeUnmount, reactive, watch } from "@vue/composition-api"

  export default {
    setup(props, context) {
      const model = reactive({
        windowWidth: -1,
        widthClass: "",
        widthStyle: ""
      })

      onMounted(() => {
        model.windowWidth = window.innerWidth

        Vue.nextTick(() => {
          window.addEventListener("resize", () => {
            model.windowWidth = window.innerWidth
          })
        })

        watch(
          () => model.windowWidth,
          (windowWidth) => {
            let containerWidth = $(context.refs.container).width()

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
        window.removeEventListener("resize", () => {
          model.windowWidth = window.innerWidth
        })
      })

      return {
        model
      }
    }
  }
</script>
