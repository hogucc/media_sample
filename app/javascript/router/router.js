import Vue from 'vue'
import VueRouter from 'vue-router'
import PostHome from '../pages/PostHome.vue'

Vue.use(VueRouter)

const router = new VueRouter({
  routes: [
    { path: '/', name: 'PostHome', component: PostHome },
  ]
})

export default router