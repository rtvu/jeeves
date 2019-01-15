<template>
  <textarea
    :value="value"
    @input="handleInput($event.target.value)">
  </textarea>
</template>

<script>
  export default {
    props: ["value"],
    methods: {
      handleInput(value) {
        this.$emit("input", value)

        this.$el.style.height = "auto"
        this.$el.style.height = this.$el.scrollHeight + "px"
      }
    },
    mounted () {
      this.$nextTick(() => {
        this.$el.setAttribute("style", "height: " + this.$el.scrollHeight + "px; overflow-y: hidden;")
      })
    }
  }
</script>
