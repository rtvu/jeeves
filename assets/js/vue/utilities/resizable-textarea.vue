<!--
  'resizable-textarea' is a wrapper around 'textarea' to specialize in fitting
  the textarea's height to the input text.
-->

<template>
  <textarea
    style="resize: none; overflow-y: hidden;"
    ref="el"
    :value="value"
    @input="handleInput">
  </textarea>
</template>

<script>
  import Vue from "vue"
  import { ref, onMounted } from "@vue/composition-api"

  // Set `eleemnt's` height to its scrollHeight.
  function fitTextHeight(element) {
    // Adjusts height if textarea is larger than inputted text.
    element.value.style.height = "auto"

    // Adjusts height if textarea is smaller than inputted text.
    element.value.style.height = element.value.scrollHeight + "px"
  }

  export default {
    props: {
      value: {
        type: String,
        default: ""
      }
    },
    setup(props, context) {
      // Define template reference.
      const el = ref(null)

      // Emits input and adjusts textarea height as necessary.
      function handleInput(event) {
        context.emit("input", event.target.value)
        fitTextHeight(el)
      }

      onMounted(() => {
        Vue.nextTick(() => {
          // Overrides default height with initial textarea height.
          fitTextHeight(el)
        })
      })

      return { el, handleInput }
    }
  }
</script>
