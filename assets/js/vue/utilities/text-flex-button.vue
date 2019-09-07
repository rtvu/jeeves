<template>
  <button
    type="button"
    style="overflow: hidden; white-space: nowrap;"

    ref="button"

    v-bind="$attrs"
    v-on="$listeners">
      <div style="display: inline-block;" ref="content"></div>
      <div style="visibility: hidden; display: inline-block; position: absolute;" ref="html"></div>
      <div style="visibility: hidden; display: inline-block; position: absolute;" ref="ellipsis">{{ model.ellipsis }}</div>
  </button>
</template>

<script>
  import $ from "jquery"
  import Vue from "vue"
  import { onMounted, onBeforeUnmount, reactive, watch } from "@vue/composition-api"

  export default {
    props: ["html"],
    setup(props, context) {
      const model = reactive({
        ellipsis: "..",
        buttonWidth: -1,
        htmlWidth: -1,
        ellipsisWidth: -1,
        selector: "None"
      })

      function getWidths() {
        model.buttonWidth = $(context.refs.button).width()
        model.htmlWidth = $(context.refs.html).width()
        model.ellipsisWidth = $(context.refs.ellipsis).width()

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
          window.addEventListener("resize", () => {
            getWidths()
          })

          watch(
            () => model.selector,
            (selector) => {
              if (selector === "None") {
                $(context.refs.content).html("")
              } else if (selector === "HTML") {
                $(context.refs.content).html(props.html)
              } else {
                $(context.refs.content).html(model.ellipsis)
              }

              context.emit("selector", {selector: selector})
            }
          )

          watch(
            () => props.html,
            (html) => {
              $(context.refs.html).html(html)

              Vue.nextTick(() => {
                getWidths()
              })
            }
          )

          Vue.nextTick(() => {
            getWidths()
          })
        })
      })

      onBeforeUnmount(() => {
        window.removeEventListener("resize", () => {
          getWidths()
        })
      })

      return {
        model
      }
    }
  }
</script>
