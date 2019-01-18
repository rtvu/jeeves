<template>
  <button
    type="button"
    style="overflow: hidden; white-space: nowrap;"

    ref="button"
    v-on="$listeners">
      <div style="display: inline-block;" ref="content">{{ buttonText }}</div>
      <div style="visibility: hidden; display: inline-block; position: absolute;" ref="text">{{ text }}</div>
      <div style="visibility: hidden; display: inline-block; position: absolute;" ref="ellipsis">{{ ellipsis }}</div>
  </button>
</template>

<script>
  import $ from "jquery"

  export default {
    props: ["text"],
    data () {
      return {
        ellipsis: "..",
        windowWidth: 0,
        buttonWidth: 0,
        textWidth: 0,
        ellipsisWidth: 0,
      }
    },
    computed: {
      buttonText () {
        if (this.buttonWidth < this.ellipsisWidth) {
          return ""
        } else if (this.buttonWidth > this.textWidth) {
          return this.text
        } else {
          return this.ellipsis
        }
      }
    },
    watch: {
      windowWidth (newWidth, oldWidth) {
        this.getWidths()
      },
      text (newText, oldText) {
        this.$nextTick(() => {
          this.getWidths()
        })
      }
    },
    mounted () {
      this.getWidths()

      this.$nextTick(() => {
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
        this.textWidth = $(this.$refs.text).width()
        this.ellipsisWidth = $(this.$refs.ellipsis).width()
      }
    }
  }
</script>
