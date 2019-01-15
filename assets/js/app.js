import '../css/app.scss';
import "phoenix_html"
import "@fortawesome/fontawesome-free/js/all"
import 'bootstrap'

import Vue from 'vue'
window.Vue = Vue
//import BootstrapVue from 'bootstrap-vue'
import draggable from 'vuedraggable'
import printerConnection from './vue/printer-connection'
import resizableTextarea from './vue/resizable-textarea'
import serverFileSelector from './vue/server-file-selector'
import displayUsers from './vue/display-users'
import requestManager from './vue/request-manager'

//Vue.use(BootstrapVue);
Vue.component('draggable', draggable)
Vue.component('printer-connection', printerConnection)
Vue.component('server-file-selector', serverFileSelector)
Vue.component('display-users', displayUsers)
Vue.component('request-manager', requestManager)
Vue.component('resizable-textarea', resizableTextarea)
// Vue.component('resizable-textarea', {
//   methods: {
//     resizeTextarea (event) {
//       event.target.style.height = 'auto'
//       event.target.style.height = (event.target.scrollHeight) + 'px'
//     },
//   },
//   mounted () {
//     this.$nextTick(() => {
//       this.$el.setAttribute('style', 'height:' + (this.$el.scrollHeight) + 'px;overflow-y:hidden;')
//     })
//
//     this.$el.addEventListener('input', this.resizeTextarea)
//   },
//   beforeDestroy () {
//     this.$el.removeEventListener('input', this.resizeTextarea)
//   },
//   render () {
//     return this.$slots.default[0]
//   },
// });
