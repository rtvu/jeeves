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

  export default {
    props: ["html"],
    data () {
      return {
        ellipsis: "..",
        windowWidth: -1,
        buttonWidth: -1,
        htmlWidth: -1,
        ellipsisWidth: -1
      }
    },
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
      html (newHTML, oldHTML) {
        $(this.$refs.html).html(newHTML)

        this.$nextTick(() => {
          this.getWidths()

          if (this.selector === "HTML") {
            $(this.$refs.content).html(this.html)
          }
        })
      }
    },
    mounted () {
      $(this.$refs.html).html(this.html)

      this.$nextTick(() => {
        this.getWidths()

        window.addEventListener("resize", () => {
          this.windowWidth = window.innerWidth
        })
      })
    },
    beforeDestroy () {
      window.removeEventListener("resize", () => {
        this.windowWidth = window.innerWidth
      })
    },
    methods: {
      getWidths () {
        this.buttonWidth = $(this.$refs.button).width()
        this.htmlWidth = $(this.$refs.html).width()
        this.ellipsisWidth = $(this.$refs.ellipsis).width()
      }
    }
  }
</script>
