<template>
  <div class="row my-2">
    <div class="col">
      <div class="input-group" ref="container">
        <div
          class="input-group-prepend"
          :class="widthClass"
          :style="widthStyle">
          <tooltip-text-flex-button
            div-class="w-100"
            button-class="btn btn-sm btn-outline-dark btn-block"
            button-style="border-top-right-radius: 0; border-bottom-right-radius: 0;"

            disabled

            :html="resource"
            :title="resource">
          </tooltip-text-flex-button>
        </div>
        <resizable-textarea
          class="form-control form-control-sm"

          :value="value"

          v-bind="$attrs"
          v-on="$listeners">
        </resizable-textarea>
      </div>
    </div>
  </div>
</template>

<script>
  import $ from "jquery"
  import Vue from "vue"
  import { onMounted, onBeforeUnmount, ref, watch } from "@vue/composition-api"
  import tooltipTextFlexButton from "../utilities/tooltip-text-flex-button"
  import resizableTextarea from "../utilities/resizable-textarea"

  export default {
    inheritAttrs: false,
    props: {
      resource: String,
      value: String
    },
    components: {
      "tooltip-text-flex-button": tooltipTextFlexButton,
      "resizable-textarea": resizableTextarea
    },
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
                // width: 500px;
                let containerWidth = $(context.refs.container).width()
                console.log("Container: " + containerWidth)
                console.log("Window: " + windowWidth)
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
