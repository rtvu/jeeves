<template>
  <div ref="div">
    <text-flex-button
      :class="buttonClass"
      :style="buttonStyle"

      :html="html"

      v-bind="$attrs"
      v-on="$listeners"
      @selector="handleSelector">
    </text-flex-button>
    <b-tooltip
      :target="() => $refs.div"
      :title="title"
      :disabled.sync="tooltipDisabled">
    </b-tooltip>
  </div>
</template>

<script>
  import textFlexButton from "./text-flex-button"

  export default {
    inheritAttrs: false,
    props: ["buttonClass", "buttonStyle", "html", "title"],
    components: {
      "text-flex-button": textFlexButton
    },
    data () {
      return {
        tooltipDisabled: true
      }
    },
    methods: {
      handleSelector (obj) {
        this.tooltipDisabled = obj.selector === "HTML"
      }
    }
  }
</script>
