import '../css/app.scss';
import "phoenix_html"
import "@fortawesome/fontawesome-free/js/all"
import 'bootstrap'

import Vue from 'vue'
window.Vue = Vue
//import BootstrapVue from 'bootstrap-vue'
import printerConnection from './vue/printer-connection'
import serverFileSelector from './vue/server-file-selector'
import displayUsers from './vue/display-users'
import requestManager from './vue/request-manager'

//Vue.use(BootstrapVue);
Vue.component('printer-connection', printerConnection)
Vue.component('server-file-selector', serverFileSelector)
Vue.component('display-users', displayUsers)
Vue.component('request-manager', requestManager)
