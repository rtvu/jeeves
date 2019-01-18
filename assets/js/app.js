import "../css/app.scss"
import "phoenix_html"
import "@fortawesome/fontawesome-free/js/all"
import "bootstrap"

import Vue from "vue"
import BootstrapVue from "bootstrap-vue"
import draggable from "vuedraggable"
import printerConnection from "./vue/printer-connection"
import serverFileSelector from "./vue/server-file-selector"
import displayUsers from "./vue/display-users"
import requestManager from "./vue/request-manager"
import textSelector from "./vue/text-selector"
import textareaSelector from "./vue/textarea-selector"

window.Vue = Vue
Vue.use(BootstrapVue);
Vue.component("draggable", draggable)
Vue.component("printer-connection", printerConnection)
Vue.component("server-file-selector", serverFileSelector)
Vue.component("display-users", displayUsers)
Vue.component("request-manager", requestManager)
Vue.component("text-selector", textSelector)
Vue.component("textarea-selector", textareaSelector)
