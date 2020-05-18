<template>
<header>
    <div class="nav">
        <router-link class="logo" to="/">
            <img src="../assets/logo.png">
        </router-link>
        <nav>
            <router-link to="/" exact>首页</router-link>
            <router-link to="/club/list">社区</router-link>
        </nav>
    </div>
    <ul class="user">
        <li v-if="!userInfo">
            <router-link to="/auth/login">登录</router-link>
            <a-divider type="vertical" />
            <router-link to="/auth/register">注册</router-link>
        </li>
        <li v-else>
            <a-dropdown>
                <a class="ant-dropdown-link" @click="e => e.preventDefault()">
                    <span>{{userInfo.nickname}}</span>
                    <img class="avatar" :src="imgUrl + userInfo.avatar">
                </a>
                <a-menu slot="overlay">
                    <a-menu-item>个人中心</a-menu-item>
                    <a-menu-item>切换社区</a-menu-item>
                    <a-menu-divider />
                    <a-menu-item @click="logout()">退出登录</a-menu-item>
                </a-menu>
            </a-dropdown>
        </li>
    </ul>
</header>
</template>

<script>
export default {
    name: 'Header',
    data() {
        return {
            userInfo: null,
            imgUrl: this.env.imgUrl
        }
    },
    mounted() {
        let info = localStorage.getItem('userInfo')
        if(info) {
            this.userInfo = JSON.parse(info)
        }
    },
    methods: {
        logout() {
            this.$http({
                url: '/api/auth/logout',
                method: 'post'
            }).then(res => {
                if(1000 == res.data.code) {
                    this.userInfo = {}
                    localStorage.clear()
                    this.$message.success('成功退出！')
                    this.$router.push('/')
                } else {
                    this.$message.error('退出失败，请重试！')
                }
            })

        }
    }
}
</script>

<style lang="less" scoped>
header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 1rem;
    height: 50px;
    // background-color: #214e98;
    // color: #fff;
    background-color: #fff;
    border-bottom: 1px solid #214e98;

    .nav {
        display: flex;
        justify-content: flex-start;
        height: 50px;

        .logo {
            overflow: hidden;
            margin-right: 1rem;
            height: 50px;

            img {
                max-height: 100%;
            }
        }

        nav {
            clear: both;

            a {
                display: block;
                padding: 0 1rem;
                line-height: 50px;
                float: left;

                &:hover, &.active {
                    color: #214e98;
                }
            }
        }
    }

    img.avatar {
        margin-left: .5rem;
        width: 32px;
        border-radius: 50%;
    }
}
</style>
