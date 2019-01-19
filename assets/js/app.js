// CSS Imports
import "../css/app.scss"

// Phoenix Imports
import "phoenix_html"

// Bootstrap Imports
import "@fortawesome/fontawesome-free/js/all"
import "bootstrap"

// Vue Imports
import Vue from "vue"
import BootstrapVue from "bootstrap-vue"
import printClient from "./vue/print-client"

window.Vue = Vue
Vue.use(BootstrapVue);
Vue.component("print-client", printClient)
