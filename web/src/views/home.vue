<template>
<div class="home">
    <Header />
    <Shortcut ref="shortcut" />
    <div class="container">
        <a-row :gutter="16">
            <a-col :span="16">
                <a-carousel autoplay>
                    <a class="slide" href="javascript:;">
                        <img src="../assets/images/2268908537.jpg">
                    </a>
                    <a class="slide" href="javascript:;">
                        <img src="../assets/images/2268908537.jpg">
                    </a>
                </a-carousel>

                <div class="box">
                    <h2>
                        <span>置顶</span>
                    </h2>
                    <ul class="topic">
                        <li class="topic-item" v-for="item in topList" :key="item.id">
                            <a class="avatar" href="javascript:;">
                                <img :src="imgUrl + item.user.avatar">
                            </a>
                            <div class="topic-info">
                                <h3>
                                    <a-badge :count="item.section.name" :numberStyle="{ backgroundColor: '#769912' }" />
                                    <router-link :to="'/topic/detail?id=' + item.id">{{item.title}}</router-link>
                                </h3>
                                <div class="author">
                                    <a href="javascript:;">{{item.user.nickname}}</a>
                                    <time>{{item.createAt}}</time>
                                    <span>{{item.replyCount}}</span>
                                </div>
                            </div>
                        </li>
                    </ul>
                </div>

                <div class="box">
                    <h2>
                        <span>
                            <a v-bind:class="{active: 2 == flag}" v-on:click="getTopic(2)">综合</a>
                            <a-divider type="vertical" />
                            <a v-bind:class="{active: 1 == flag}" v-on:click="getTopic(1)">未结</a>
                            <a-divider type="vertical" />
                            <a v-bind:class="{active: 0 == flag}" v-on:click="getTopic(0)">已结</a>
                            <a-divider type="vertical" />
                            <a v-bind:class="{active: 3 == flag}" v-on:click="getTopic(3)">精华</a>
                        </span>
                    </h2>
                    <ul class="topic">
                        <li class="topic-item" v-for="item in topicList" :key="item.id">
                            <a class="avatar" href="">
                                <img :src="imgUrl + item.user.avatar">
                            </a>
                            <div class="topic-info">
                                <h3>
                                    <a-badge :count="item.section.name" :numberStyle="{ backgroundColor: '#769912' }" />
                                    <router-link :to="'/topic/detail?id=' + item.id">{{item.title}}</router-link>
                                </h3>
                                <div class="author">
                                    <a href="javascript:;">{{item.user.nickname}}</a>
                                    <time>{{item.createAt}}</time>
                                    <span>{{item.replyCount}}</span>
                                </div>
                            </div>
                        </li>
                    </ul>
                    <div class="more">
                        <a class="btn-more" href="javascript:;" v-on:click="getTopic()">查看更多</a>
                    </div>
                </div>
            </a-col>
            <a-col :span="8">
                <div class="box">
                    <h2>
                        <span>
                            签到
                            <a-divider type="vertical" />
                            <a v-on:click="setState">说明</a>
                            <a-modal class="exp-sign" title="签到说明" v-model="visible" width="360px" :footer="null">
                                <h3>
                                    ”签到“可获得社区篱笆，规则如下
                                </h3>
                                <table>
                                    <thead>
                                        <tr>
                                            <th>连续签到天数</th>
                                            <th>每天可获篱笆</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>&lt;5</td>
                                            <td>5</td>
                                        </tr>
                                        <tr>
                                            <td>≥5</td>
                                            <td>10</td>
                                        </tr>
                                        <tr>
                                            <td>≥15</td>
                                            <td>15</td>
                                        </tr>
                                    </tbody>
                                </table>
                                <ul>
                                    <li>中间若有间隔，则连续天数重新计算</li>
                                    <li>不可利用程序自动签到，否则篱笆清零</li>
                                </ul>
                            </a-modal>
                        </span>
                        <div class="action" v-if="isLogin">已连续签到 0 天</div>
                    </h2>
                    <div class="sign-in">
                        <a-button type="danger" v-on:click="setSign">今日签到</a-button>
                        <span v-if="isLogin">可获得5篱笆</span>
                    </div>
                </div>
                <div class="box">
                    <h2>
                        <span>
                            超级赞助商
                            <a-divider type="vertical" />
                            <a href="javascript:;">我要加入</a>
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
                <div class="box">
                    <h2>
                        <span>回帖周榜</span>
                    </h2>
                    <div class="rank">
                        <a-row :gutter="16">
                            <a-col :span="6" v-for="item in rankList" :key="item.id">
                                <a href="javascript:;">
                                    <div class="avatar">
                                        <img :src="imgUrl + item.avatar">
                                        <cite>{{item.nickname}}</cite>
                                    </div>
                                    <p>{{item.replyCount}}次回答</p>
                                </a>
                            </a-col>
                        </a-row>
                    </div>
                </div>
                <div class="box">
                    <h2>
                        <span>友情链接</span>
                    </h2>
                    <div class="link">
                        <a href="http://www.baidu.com" target="_blank">百度</a>
                        <a href="http://www.alibaba.com" target="_blank">阿里巴巴</a>
                    </div>
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
    name: 'Home',
    components: {
        Header,
        Shortcut,
        Footer
    },
    data() {
        return {
            topList: [],
            topicList: [],
            flag: 2,
            visible: false,
            isLogin: false,
            adList: [],
            rankList: [],
            imgUrl: this.env.imgUrl
        }
    },
    mounted() {
        let info = localStorage.getItem('userInfo')
        if(info) {
            this.isLogin = true
        }
        this.getTop()
        this.getTopic()
        this.getRank()
    },
    methods: {
        // 置顶
        getTop() {
            this.$http({
                method: 'get',
                url: '/api/topic/getList',
                params: {
                    page: 1,
                    pageSize: 3,
                    isTop: 1
                }
            }).then(res => {
                if(1200 == res.data.code) {
                    this.topList = res.data.list
                } else {
                    this.topList = []
                }
            })
        },
        getTopic(flag = null) {
            if(undefined != flag) {
                this.flag = flag
            }
            this.$http({
                method: 'get',
                url: '/api/topic/getList',
                params: {
                    page: 1,
                    pageSize: 10,
                    flag: this.flag
                }
            }).then(res => {
                if(1200 == res.data.code) {
                    this.topicList = res.data.list
                }
            })
        },
        // 签到说明
        setState() {
            if(!this.visible) {
                this.visible = true
                return
            }
        },
        // 签到
        setSign() {
            if(!this.isLogin) {
                this.$router.push('/auth/login')
                return
            }
            this.$http({
                url: '/api/user/setSign',
                method: 'post'
            }).then(res => {
                if(1000 == res.data.code) {
                    this.$message.success('签到成功！')
                } else {
                    this.$message.warning('今日您已签到！')
                }
            })
        },
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
        },
        getRank() {
            this.$http({
                url: '/api/user/weekRank',
                method: 'get',
                params: {
                    page: 1,
                    pageSize: 10
                }
            }).then(res => {
                if(1200 == res.data.code) {
                    this.rankList = res.data.list
                }
            })
        }

    }
}
</script>

<style lang="less" scoped>
.home {
    background-color: #f2f2f2;
    min-height: 750px;

    .ant-carousel {
        margin-bottom: 1rem;
    }
}

/* 签到 */
.sign-in {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100px;

    span {
        margin-left: 1rem;
    }
    .ant-btn-danger {
        background-color: #769912;
        border-color: #769912;
        height: 36px;
    }
}

.exp-sign {
    h3 {
        border-left: 5px solid #769912;
        padding-left: 1rem;
    }
    table {
        width: 100%;
        border: 1px solid #ddd;
        tr {
            border: 1px solid #ddd;
        }
        th {
            background-color: wheat;
        }
        th,td {
            line-height: 34px;
            padding: 2px 8px;
            border: 1px solid #ddd;
        }
    }
    ul {
        list-style-type: square;
        margin-top: 1rem;
        margin-left: 1rem;
        li{
            line-height: 34px;
            &:last-child {
                color: #f40;
            }
        }
    }
}

.rank {
    padding: 1rem;

    a {
        display: flex;
        justify-content: center;
        flex-direction: column;
        width: 100%;
        text-align: center;
    }

    .avatar {
        overflow: hidden;
        position: relative;

        img {
            width: 100%;
        }

        cite {
            position: absolute;
            left: 0;
            bottom: 0;
            display: block;
            width: 100%;
            padding: 2px 8px;
            background-color: #000;
            opacity: .3;
            color: #fff;
        }
    }
}

.link {
    display: inline-block;

    a {
        margin: 1rem;
        float: left;
    }
}
</style>
