<template>
  <div class="input-group" ref="container">
    <div
      class="input-group-prepend"
      :class="widthClass"
      :style="widthStyle">
      <slot name="selector-prepend"></slot>
    </div>
    <slot name="selector"></slot>
  </div>
</template>

<script>
  import $ from "jquery"
  import Vue from "vue"
  import { onMounted, onBeforeUnmount, ref, watch } from "@vue/composition-api"

  export default {
    setup(props, context) {
      const windowWidth = ref(-1)
      const widthClass = ref("")
      const widthStyle = ref("")

      onMounted(() => {
        Vue.nextTick(() => {
          windowWidth.value = window.innerWidth

          window.addEventListener("resize", () => {
            windowWidth.value = window.innerWidth
          })

          Vue.nextTick(() => {
            watch(
              windowWidth,
              (windowWidth) => {
                let containerWidth = $(context.refs.container).width()

                if (containerWidth < 350) {
                  widthClass.value = "w-100"
                  widthStyle.value = ""
                } else if (containerWidth < 725) {
                  widthClass.value = ""
                  widthStyle.value = "width: " + Math.floor(containerWidth * 0.3) + "px;"
                } else {
                  widthClass.value = ""
                  widthStyle.value = "width: 217px;"
                }
              }
            )
          })
        })
      })

      onBeforeUnmount(() => {
        window.removeEventListener("resize", () => {
          windowWidth.value = window.innerWidth
        })
      })

      return {
        widthClass,
        widthStyle
      }
    }
  }
</script>
