import Vue from 'vue'
import VueRouter from 'vue-router'
import PostHome from '../pages/PostHome.vue'
import PostCreate from '../pages/PostCreate.vue'

Vue.use(VueRouter)

const routes = [
  { path: '/', name: 'PostHome', component: PostHome },
  { path: '/create', component: PostCreate},
];

export default new VueRouter({ routes });