import Vue from 'vue'
import App from './App.vue'
import Router from '../router/router.js'
import { library } from '@fortawesome/fontawesome-svg-core'
import { fas } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

library.add(fas)

Vue.component('font-awesome-icon', FontAwesomeIcon)

const app = new Vue({
  el: '#app',
  router: Router,
  render: h => h(App)
})
