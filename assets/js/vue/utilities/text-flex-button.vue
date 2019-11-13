<!--
  'text-flex-button' is a wrapper around 'button' to specialize in either
  displaying the button's content, ellipsis, or nothing depending on the
  button's width.
-->

<template>
  <button
    type="button"
    style="overflow: hidden; white-space: nowrap;"
    ref="buttonRef"
    v-on="$listeners">
      <div style="display: inline-block;" ref="contentRef"></div>
      <div style="visibility: hidden; display: inline-block; position: absolute;" ref="htmlRef"></div>
      <div style="visibility: hidden; display: inline-block; position: absolute;" ref="ellipsisRef">{{ model.ellipsis }}</div>
  </button>
</template>

<script>
  import $ from "jquery"
  import Vue from "vue"
  import { onMounted, onBeforeUnmount, reactive, ref, watch } from "@vue/composition-api"

  export default {
    props: {
      html: {
        type: String,
        default: ""
      }
    },
    setup(props, context) {
      // Define template references.
      const buttonRef = ref(null)
      const contentRef = ref(null)
      const htmlRef = ref(null)
      const ellipsisRef = ref(null)

      // Component's internal data.
      const model = reactive({
        ellipsis: "..",
        buttonWidth: -1,
        htmlWidth: -1,
        ellipsisWidth: -1,
        selector: null
      })

      // Updates `model.selector` based on the widths of button, html, and
      // ellipsis.
      function updateSelector() {
        model.buttonWidth = $(buttonRef.value).width()
        model.htmlWidth = $(htmlRef.value).width()
        model.ellipsisWidth = $(ellipsisRef.value).width()

        if (model.buttonWidth < model.ellipsisWidth) {
          model.selector = "None"
        } else if (model.buttonWidth > model.htmlWidth) {
          model.selector = "HTML"
        } else {
          model.selector = "Ellipsis"
        }
      }

      onMounted(() => {
        Vue.nextTick(() => {
          // Run `updateSelector` whenever window's resize event is triggered.
          window.addEventListener("resize", updateSelector)

          // Initialize `model.selector`.
          updateSelector()

          // 'model.selector' change triggers setting html of `contentRef` and
          // emitting "selector" event.
          watch(
            () => model.selector,
            (selector) => {
              if (selector === "None") {
                $(contentRef.value).html("")
              } else if (selector === "HTML") {
                $(contentRef.value).html(props.html)
              } else {
                $(contentRef.value).html(model.ellipsis)
              }

              context.emit("selector", {selector: selector})
            }
          )

          // 'props.html' change triggers setting html of `htmlRef` and
          // requires running `updateSelector` on the next tick.
          watch(
            () => props.html,
            (html) => {
              $(htmlRef.value).html(html)

              Vue.nextTick(() => {
                updateSelector()
              })
            }
          )
        })
      })

      onBeforeUnmount(() => {
        window.removeEventListener("resize", updateSelector)
      })

      return {
        buttonRef,
        contentRef,
        htmlRef,
        ellipsisRef,
        model
      }
    }
  }
</script>
