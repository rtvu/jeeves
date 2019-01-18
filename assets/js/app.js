import "../css/app.scss"
import "phoenix_html"
import "@fortawesome/fontawesome-free/js/all"
import "bootstrap"

import Vue from "vue"
import BootstrapVue from "bootstrap-vue"
import draggable from "vuedraggable"
import printerConnection from "./vue/printer-connection"
import resizableTextarea from "./vue/resizable-textarea"
import serverFileSelector from "./vue/server-file-selector"
import displayUsers from "./vue/display-users"
import requestManager from "./vue/request-manager"
import textSelector from "./vue/text-selector"

window.Vue = Vue
Vue.use(BootstrapVue);
Vue.component("draggable", draggable)
Vue.component("printer-connection", printerConnection)
Vue.component("server-file-selector", serverFileSelector)
Vue.component("display-users", displayUsers)
Vue.component("request-manager", requestManager)
Vue.component("resizable-textarea", resizableTextarea)
Vue.component("text-selector", textSelector)
