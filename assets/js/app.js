import "phoenix_html"

import Vue from 'vue'
import BootstrapVue from 'bootstrap-vue'
import printerConnection from './vue/printer-connection'
import serverFileSelector from './vue/server-file-selector'

Vue.use(BootstrapVue);
Vue.component('printer-connection', printerConnection)
Vue.component('server-file-selector', serverFileSelector)
