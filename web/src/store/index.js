import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
      user: JSON.parse(localStorage.getItem('user')) || null
  },
  mutations: {
      updateUser(state, info) {
        state.user = info
      }
  },
  actions: {
      updateUser(ctx, param) {
        ctx.state.userInfo = param
      }
  },
  modules: {
  }
})
