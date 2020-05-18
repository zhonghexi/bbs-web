import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

const routes = [
    {
        path: '/',
        name: 'Home',
        meta: { title: '篱笆客_社区' },
        component: () => import('../views/home.vue'),
    },
    {
        path: '/auth',
        name: 'Index',
        meta: { title: '篱笆客' },
        component: () => import('../views/auth/index.vue'),
        children: [{
            path: 'login',
            name: 'Login',
            meta: { title: '登录'},
            component: () => import('../views/auth/login.vue')
        },{
            path: 'register',
            name: 'Register',
            meta: { title: '注册'},
            component: () => import('../views/auth/register.vue')
        }]
    },
    {
        path: '/user',
        name: 'Index',
        meta: { title: '篱笆客_个人主页' },
        component: () => import('../views/user/index.vue'),
        children: [{
            path: 'collect',
            name: 'Collect',
            meta: { title: '收藏'},
            component: () => import('../views/user/collect.vue')
        }]
    },
    {
        path: '/club',
        name: 'Index',
        meta: { title: '篱笆客_社区' },
        component: () => import('../views/club/index.vue'),
        children: [{
            path: 'detail',
            name: 'Detail',
            meta: { title: '篱笆客_社区详情'},
            component: () => import('../views/club/detail.vue')
        },{
            path: 'list',
            name: 'List',
            meta: { title: '篱笆客_社区列表'},
            component: () => import('../views/club/list.vue')
        }]
    },
    {
        path: '/section',
        name: 'Section',
        meta: { title: '篱笆客_版块' },
        component: () => import('../views/section.vue'),
    },
    {
        path: '/topic',
        name: 'Index',
        meta: { title: '篱笆客_贴子' },
        component: () => import('../views/topic/index.vue'),
        children: [{
            path: 'publish',
            name: 'Publish',
            meta: { title: '篱笆客_发表贴子' },
            component: () => import('../views/topic/publish'),
            beforeEnter: (to, from, next) => {
                // if() {

                // }
                console.log(to, from, next)
                next()
            }
        },{
            path: 'detail',
            name: 'Detail',
            meta: { title: '篱笆客_贴子详情' },
            component: () => import('../views/topic/detail')
        }]
    }
]

const router = new VueRouter({
    mode: 'history',
    linkActiveClass: 'active',
    routes
})

export default router
