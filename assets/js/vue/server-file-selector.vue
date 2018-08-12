<template>
  <div class="row my-1">
    <div class="col-3">
      <button type="button" class="btn btn-sm btn-dark btn-block" @click="click">{{ resource }}</button>
    </div>
    <div class="col">
      <input type="text" class="form-control form-control-sm" readonly v-model="value">
    </div>
  </div>
</template>

<script>
  export default {
    props: ["resource", "startPath"],
    data () {
      return {
        value: ""
      }
    },
    methods: {
      click: function () {
        this.value = this.value + "click"
      }
    }
  }
</script>
