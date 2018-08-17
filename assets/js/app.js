import "phoenix_html"

import Vue from 'vue'
import BootstrapVue from 'bootstrap-vue'
import serverFileSelector from './vue/server-file-selector'

Vue.use(BootstrapVue);
Vue.component('server-file-selector', serverFileSelector)
