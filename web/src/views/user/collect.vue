<template>
<div class="collect">
    <Header />
    <div class="container">
        <h1 class="user">
            <img :src="imgUrl + userInfo.avatar">
            <div class="info">
                <span>{{userInfo.nickname}}</span>
                <p>{{userInfo.brief}}</p>
            </div>
        </h1>
        <h2>原创</h2>
        <a-row :gutter="16">
            <a-col :span="6" v-for="item in topicList" :key="item.id">
                <div class="c-item">
                    <h3><router-link :to="'/topic/detail?id=' + item.id">{{item.title}}</router-link></h3>
                    <p v-html="item.detail"></p>
                </div>
            </a-col>
        </a-row>
        <h2>收藏</h2>
        <a-row :gutter="16">
            <a-col :span="6" v-for="item in collectList" :key="item.id">
                <div class="c-item">
                    <h3><router-link :to="'/topic/detail?id' + item.id">{{item.title}}</router-link></h3>
                    <p v-html="item.detail"></p>
                    <a class="iconfont cancel" v-if="item.user_id == loginInfo.id" title="取消收藏">&#xe69f;</a>
                </div>
            </a-col>
        </a-row>
    </div>
    <Footer />
</div>
</template>

<script>
import Header from '@/components/header'
import Footer from '@/components/footer'

export default {
    name: 'Collect',
    components: {
        Header,
        Footer
    },
    data() {
        return {
            imgUrl: this.env.imgUrl,
            userInfo: {},
            topicList: [],
            loginInfo: {},
            collectList: []
        }
    },
    mounted() {
        this.getTopic()
        this.getCollect()
        this.loginInfo = localStorage.getItem('userInfo')
        if(undefined == this.loginInfo) {
            this.loginInfo = {}
        }
        this.getUser()
    },
    methods: {
        getUser() {
            let data = {
                username: this.$route.query.username
            }
            this.$http({
                url: '/api/user/getInfo',
                method: 'post',
                data: data
            }).then(res => {
                if(1100 == res.data.code) {
                    this.userInfo = res.data.info
                }
            })
        },

        getTopic() {
            let params = {
                page: 1,
                pageSize: 10,
                userId: this.$route.query.userId
            }
            this.$http({
                url: '/api/topic/getList',
                method: 'get',
                params: params
            }).then(res => {
                if(1200 == res.data.code) {
                    this.topicList = res.data.list
                } else {
                    this.topicList = []
                }
            })
        },

        getCollect() {
            let params = {
                page: 1,
                pageSize: 10,
                userId: this.$route.query.userId
            }
            this.$http({
                url: '/api/user/collect',
                method: 'get',
                params: params
            }).then(res => {
                if(1200 == res.data.code) {
                    this.collectList = res.data.list
                } else {
                    this.collectList = []
                }
            })
        }
    }
}
</script>

<style lang="less" scoped>
.collect {

    .user {
        font-size: 1rem;
        overflow: hidden;

        img {
            height: 80px;
            border-radius: 4px;
            margin-right: .5rem;
        }

        .info {
            display: inline-block;
            height: 80px;

            p {
                margin-bottom: 0;
                vertical-align: bottom;
                color: #999;
            }

        }

    }

    h2 {
        margin-top: 2rem;
    }

    .c-item {
        position: relative;
        padding: .5rem 1rem;
        background-color: #f2f2f2;
        border-radius: 4px;

        &:hover {
            box-shadow: 0 0 6px 0 rgba(0, 0, 0, 0.1);
            .cancel {
                display: block;
            }
        }

        h3 {
            max-width: 240px;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }

        p {
            display: inline-block;
            height: 60px;
            line-height: 20px;
            overflow: hidden;
            color: #999;
        }

        .cancel {
            display: none;
            position: absolute;
            top: 4px;
            right: 8px;
            font-size: 1.25rem;
            color: #999;
        }
    }
}

.container {
    margin-top: 1.5rem;
}
</style>
