<template>
  <form>
    <div class="row my-1">
      <div class="col-2">
        <div
          v-b-tooltip.hover
          :title="resource">
          <text-flex-button
            class="btn btn-sm btn-outline-dark btn-block"
            disabled

            :text="resource">
          </text-flex-button>
        </div>
      </div>
      <div class="col">
        <input
          type="text"
          class="form-control form-control-sm"

          :value="value"
          @input="$emit('input', $event.target.value)">
      </div>
    </div>
  </form>
</template>

<script>
  import textFlexButton from "../utilities/text-flex-button"

  export default {
    props: {
      resource: String,
      value: String
    },
    components: {
      "text-flex-button": textFlexButton
    },
    data () {
      return {}
    }
  }
</script>
