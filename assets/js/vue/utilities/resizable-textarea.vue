<template>
  <textarea
    :value="value"
    v-on="listeners">
  </textarea>
</template>

<script>
  export default {
    props: ["value"],
    computed: {
      listeners () {
        return Object.assign({}, this.$listeners, {
          input: () => {
            this.$emit("input", event.target.value)

            this.$el.style.height = "auto"
            this.$el.style.height = this.$el.scrollHeight + "px"
          }
        })
      }
    },
    mounted () {
      this.$nextTick(() => {
        this.$el.setAttribute("style", "height: " + this.$el.scrollHeight + "px; overflow-y: hidden;")
      })
    }
  }
</script>
