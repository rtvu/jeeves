<!--
  'resizable-textarea' is a wrapper around 'textarea' to specialize in fitting
  the textarea's height to the input text.
-->

<template>
  <textarea
    style="resize: none; overflow-y: hidden;"
    ref="textareaRef"
    :value="value"
    @input="handleInput">
  </textarea>
</template>

<script>
  import Vue from "vue"
  import { ref, onMounted } from "@vue/composition-api"

  // Set `element's` height to its scrollHeight.
  function fitTextHeight(element) {
    // Adjusts height if textarea is larger than inputted text.
    element.style.height = "auto"

    // Adjusts height if textarea is smaller than inputted text.
    element.style.height = element.scrollHeight + "px"
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
      const textareaRef = ref(null)

      // Emits input and adjusts textarea height as necessary.
      function handleInput(event) {
        context.emit("input", event.target.value)
        fitTextHeight(textareaRef.value)
      }

      onMounted(() => {
        Vue.nextTick(() => {
          // Overrides default height with initial textarea height.
          fitTextHeight(textareaRef.value)
        })
      })

      return { textareaRef, handleInput }
    }
  }
</script>
