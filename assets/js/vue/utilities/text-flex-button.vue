<template>
  <button
    type="button"
    style="overflow: hidden; white-space: nowrap;"

    ref="button"

    v-bind="$attrs"
    v-on="$listeners">
      <div style="display: inline-block;" ref="content"></div>
      <div style="visibility: hidden; display: inline-block; position: absolute;" ref="html"></div>
      <div style="visibility: hidden; display: inline-block; position: absolute;" ref="ellipsis">{{ ellipsis }}</div>
  </button>
</template>

<script>
  import $ from "jquery"
  import Vue from "vue"
  import { onMounted, onBeforeUnmount, ref, watch, computed } from "@vue/composition-api"

  export default {
    props: ["html"],
    setup(props, context) {
      const model = reactive({
        ellipsis: "..",
        windowWidth: -1,
        buttonWidth: -1,
        htmlWidth: -1,
        ellipsisWidth: -1,
      })

      function getWidths() {
        model.buttonWidth = $(context.refs.button).width()
        model.htmlWidth = $(context.refs.html).width()
        model.ellipsisWidth = $(context.refs.ellipsis).width()
      }

      onMounted(() => {
        $(context.refs.html).html(props.html)

        Vue.nextTick(() => {
          // getWidths()

          window.addEventListener("resize", () => {
            windowWidth.value = window.innerWidth
          })
        })
      })

      onBeforeUnmount(() => {
        window.removeEventListener("resize", () => {
          windowWidth.value = window.innerWidth
        })
      })

      watch(
        () => props.html,
        (html) => {
          $(context.refs.html).html(html)

          Vue.nextTick(() => {
            getWidths()

            Vue.nextTick(() => {
              if (selector.value === "HTML") {
                $(context.refs.content).html(html)
              }
            })
          })
        }
      )



      return {}
    }

    computed: {
      selector () {
        if (this.windowWidth === this.buttonWidth && this.windowWidth === this.htmlWidth && this.windowWidth === this.ellipsisWidth && this.windowWidth === -1) {
          return "Initializing"
        } else if (this.buttonWidth < this.ellipsisWidth) {
          return "None"
        } else if (this.buttonWidth > this.htmlWidth) {
          return "HTML"
        } else {
          return "Ellipsis"
        }
      }
    },
    watch: {
      windowWidth (newWidth, oldWidth) {
        this.getWidths()
      },
      selector (newSelector, oldSelector) {
        if (newSelector === "None") {
          $(this.$refs.content).html("")
        } else if (newSelector === "HTML") {
          $(this.$refs.content).html(this.html)
        } else {
          $(this.$refs.content).html("..")
        }

        this.$emit("selector", {selector: newSelector})
      },

    },

  }
</script>
