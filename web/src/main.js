import Vue from 'vue'
import Antd from 'ant-design-vue'
import App from './app.vue'
import router from './router'
import store from './store'
import axios from 'axios'
import 'ant-design-vue/dist/antd.css'
import './assets/font/iconfont.css'
import './assets/style.less'

Vue.config.productionTip = false

if('development' == process.env.NODE_ENV) {
    Vue.prototype.env = require('./config/dev.env')
} else {
    Vue.prototype.env = require('./config/prod.env')
}

Vue.use(Antd)

// 拦截器
axios.interceptors.response.use(res => {
    switch(res.data.code) {
        case 2990:
            localStorage.clear()
            router.push({path: 'auth/login'})
    }
    return res
}, err => {
    console.log(err)
})

Vue.prototype.$http = axios

// 根据路由设置标题
router.beforeEach((to, from, next) => {
    if (to.meta.title) {
        document.title = to.meta.title
    }
    next();
})

new Vue({
    router,
    store,
    render: h => h(App)
}).$mount('#app')
