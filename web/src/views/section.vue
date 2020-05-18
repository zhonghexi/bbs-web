<template>
<div class="section">
    <Header />
    <Shortcut />
    <div class="container">
        <a-row :gutter="16">
            <a-col :span="16">
                <div class="box">
                    <h2>
                        <span>
                            <a v-bind:class="{active: 2 == flag}" v-on:click="setFlag(2)">综合</a>
                            <a-divider type="vertical" />
                            <a v-bind:class="{active: 1 == flag}" v-on:click="setFlag(1)">未结</a>
                            <a-divider type="vertical" />
                            <a v-bind:class="{active: 0 == flag}" v-on:click="setFlag(0)">已结</a>
                            <a-divider type="vertical" />
                            <a v-bind:class="{active: 3 == flag}" v-on:click="setFlag(3)">精华</a>
                        </span>
                    </h2>
                    <a-skeleton :loading="loading" avatar>
                        <ul class="topic">
                        <li class="topic-item" v-for="item in topicList" :key="item.id">
                            <a class="avatar" href="javascript:;">
                                <img src="../assets/images/avatar/01.jpg">
                            </a>
                            <div class="topic-info">
                                <h3>
                                    <a-badge :count="item.section.name" :numberStyle="{ backgroundColor: '#769912' }" />
                                    <router-link :to="'/topic/detail?id=' + item.id">{{item.title}}</router-link>
                                </h3>
                                <div class="author">
                                    <a href="">{{item.user.nickname}}</a>
                                    <time>{{item.createAt}}</time>
                                    <span>{{item.replyCount}}</span>
                                </div>
                            </div>
                        </li>
                    </ul>
                    </a-skeleton>
                    <div class="more">
                        <a class="btn-more" v-on:click="setPage">查看更多</a>
                    </div>
                </div>
            </a-col>
            <a-col :span="8">
                <div class="box">
                    <h2>
                        <span>本周热议</span>
                    </h2>
                    <ul class="week-hot">
                        <li v-for="item in rankList" :key="item.id">
                            <router-link :to="'/topic/detail?id=' + item.id">{{item.title}}</router-link>
                            <span>
                                <i class="iconfont">&#xe635;</i>&nbsp;{{item.replyCount}}
                            </span>
                        </li>
                    </ul>
                </div>
                <div class="box">
                    <h2>
                        <span>
                            超级赞助商
                            <a-divider type="vertical" />
                            <a href="">我要加入</a>
                        </span>
                    </h2>
                    <ul class="advert">
                        <li v-for="item in adList" :key="item.id">
                            <router-link :to="item.url">
                                <img :src="item.assets">
                            </router-link>
                        </li>
                    </ul>
                </div>
            </a-col>
        </a-row>
    </div>
    <Footer />
</div>
</template>

<script>
import Header from '@/components/header.vue'
import Shortcut from '@/components/shortcut.vue'
import Footer from '@/components/footer.vue'

export default {
    name: 'Section',
    components: {
        Header,
        Shortcut,
        Footer
    },
    data() {
        return {
            page: 1,
            pageSize: 10,
            sectionId: 0,
            flag: 2,
            topicList: [],
            rankList: [],
            adList: [],
            loading: true
        }
    },
    mounted() {
        this.getTopic()
        this.getRank()
        this.getAdvert()
    },
    watch: {
        '$route' (to){
            this.sectionId = to.query.id
            this.page = 1
            this.getTopic(true)
        }
    },
    methods: {
        getTopic(refresh = false) {
            this.$http({
                url: '/api/topic/getList',
                method: 'get',
                params: {
                    page: this.page,
                    pageSize: this.pageSize,
                    sectionId: this.sectionId,
                    flag: this.flag
                }
            }).then(res => {
                if(1200 == res.data.code) {
                    this.loading = false
                    if(refresh){
                        this.topicList = res.data.list
                    } else {
                        this.topicList = this.topicList.concat(res.data.list)
                    }
                }
            })
        },
        getRank() {
            this.$http({
                url: '/api/topic/getList',
                method: 'get',
                params: {
                    page: this.page,
                    pageSize: this.pageSize,
                    isRank: 1
                }
            }).then(res => {
                if(1200 == res.data.code) {
                    this.rankList = res.data.list
                }
            })
        },
        setPage(e) {
            e.preventDefault()
            this.page += 1
            this.getTopic()
        },
        setFlag(f) {
            this.page = 1
            this.flag = f
            this.getTopic()
        },
        // 广告
        getAdvert() {
            this.$http({
                url: '/api/advert/getList',
                method: 'get',
                params: {
                    page: 1,
                    pageSize: 3,
                    place: 'r-b',
                    type: 1
                }
            }).then(res => {
                if(1200 == res.data.code) {
                    this.adList = res.data.list
                }
            })
        }
    }
}
</script>

<style lang="less" scoped>
.section {
    background-color: #f2f2f2;
}
.ant-skeleton {
    padding: 1rem;
}
</style>
