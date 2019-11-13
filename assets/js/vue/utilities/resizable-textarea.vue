<!--
  'resizable-textarea' is a wrapper around 'textarea' to sepcialize in fitting
  the textarea's height around the inputted text.
-->

<template>
  <textarea
    :value="value"
    v-on="listeners">
  </textarea>
</template>

<script>
  import Vue from "vue"
  import { computed, onMounted } from "@vue/composition-api"

  export default {
    props: {
      value: {
        type: String,
        default: ""
      }
    },
    setup(props, context) {
      console.log(context)
      const listeners = computed(() => {
        return {}
        // return Object.assign({}, this.$listeners, {
        //   input: () => {
        //     this.$emit("input", event.target.value)
        //
        //     this.$el.style.height = "auto"
        //     this.$el.style.height = this.$el.scrollHeight + "px"
        //   }
        // })
      })

      onMounted(() => {
        Vue.nextTick(() => {
          // this.$el.style.height = this.$el.scrollHeight + "px"
          // this.$el.style.overflowY = "hidden"
          // this.$el.style.resize = "none"
        })
      })

      return { listeners }
    }
  }
</script>
