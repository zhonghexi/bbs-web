<template>
<div class="club">
    <Header />
    <div class="container">
        <a-row :gutter="16">
            <a-col :span="16">
                <div class="club-intro">
                    <i class="iconfont">&#xe615;</i>
                    <span>
                        <h1>{{clubInfo.name}}</h1>
                        <p>{{clubInfo.brief}}</p>
                    </span>
                </div>
                <div class="club-item" v-for="item in topicList" :key="item.id">
                    <h2>
                        <router-link :to="'/topic/detail?id=' + item.id">{{item.title}}</router-link>
                    </h2>
                    <div class="club-admin">
                        <a class="avatar" href="javascript:;">
                            <img :src="imgUrl + item.user.avatar">
                            <cite>{{item.user.nickname}}</cite>
                        </a>
                        <time>{{item.createAt}} 发布</time>
                        <a class="apply" @click="doCollect(item.id)">
                            <i class="iconfont">&#xe615;</i>&nbsp;收藏
                        </a>
                    </div>
                    <div class="topic-detail" :to="'/topic/detail?id=' + item.id">
                        {{item.detail}}
                    </div>
                </div>
            </a-col>
            <a-col :span="8">
                <form class="topic-filter" @submit="e => {e.preventDefault();onSearch()}">
                    <div class="form-item">
                        <label><strong>{{total}}</strong>&nbsp;篇帖子</label>
                        <div class="input-group">
                            <input name="keyword" type="text" v-model="keyword" placeholder="请输入您要查找的文章标题">
                            <button type="submit">搜索</button>
                        </div>
                    </div>
                    <div class="tag">
                        <a @click="onSearch('百度')">百度</a>
                        <a @click="onSearch('阿里巴巴')">阿里巴巴</a>
                        <a @click="onSearch('华为')">华为</a>
                    </div>
                </form>
                <div class="club-hot">
                    <h2>6&nbsp;位成员</h2>
                    <div class="hot-item" v-for="item in memberList" :key="item.id">
                        <a href="">
                            <img :src="imgUrl + item.avatar">
                        </a>
                        <div class="info">
                            <a href="">
                                <h3>{{item.nickname}}</h3>
                            </a>
                            <p>{{item.brief}}</p>
                        </div>
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
import Footer from '@/components/footer.vue'

export default {
    name: 'Club',
    components: {
        Header,
        Footer
    },
    data() {
        return {
            id: null,
            clubInfo: {},
            topicList: [],
            total: 0,
            keyword: null,
            memberList: [],
            imgUrl: this.env.imgUrl
        }
    },
    mounted() {
        this.id = this.$route.query.id
        this.getClub()
        this.getMember()
    },
    methods: {
        getClub(params = {}) {
            params = Object.assign({
                id: this.id,
                page: 1,
                pageSize: 10
            }, params)
            this.$http({
                url: '/api/club/getInfo',
                method: 'get',
                params: params
            }).then(res => {
                if (1100 == res.data.code) {
                    this.clubInfo = res.data.info
                    if (undefined != res.data.info.topic) {
                        this.topicList = res.data.info.topic.list
                        this.total = res.data.info.topic.total
                    }
                }
            })
        },

        onSearch(keyword = null) {
            if(undefined != keyword) {
                this.keyword = keyword
            }
            this.getClub({kw: this.keyword})
        },

        getMember() {
            this.$http({
                url: '/api/club/member',
                method: 'get',
                params: {
                    id: this.id,
                    page: 1,
                    pageSize: 10
                }
            }).then(res => {
                if(1200 == res.data.code) {
                    this.memberList = res.data.list
                }
            })
        },

        // 收藏
        doCollect(topicId) {
            this.$http({
                url: '/api/user/doCollect',
                method: 'post',
                data: {
                    topicId: topicId
                }
            }).then(res => {
                if(1000 == res.data.code) {
                    this.$message.success('收藏成功！')
                } else {
                    this.$message.error('已收藏哦！')
                }
            })
        }
    }
}
</script>

<style lang="less" scoped>
.club-intro {
    display: flex;
    justify-self: start;
    margin-top: 1rem;
    border-bottom: 1px solid #ddd;

    .iconfont {
        font-size: 3rem;

    }

    span {
        margin-left: .5rem;

        h1 {
            margin-bottom: 0;
        }
    }
}

.club-item {
    padding-top: 1rem;
    border-bottom: 1px dotted #ddd;

    &:last-child {
        border-bottom: 0;
    }

    .club-admin {
        padding: .5rem 0;

        .avatar {
            img {
                width: 32px;
                height: 32px;
                border-radius: 50%;
            }

            cite {
                margin-left: .5rem;
            }
        }

        .apply {
            margin-left: 1rem;
        }
        time {
            margin-left: 1rem;
        }
    }

    .topic-detail {
        display: -webkit-box;
        -webkit-box-orient: vertical;
        -webkit-line-clamp: 3;
        overflow: hidden;
        color: #999;
        margin-bottom: 1rem;
    }
}

.topic-filter {
    margin-top: 1rem;

    strong {
        color: #769912;
    }

    .input-group {
        margin-top: .5rem;

        input {
            min-width: 300px;
            height: 36px;
            padding-left: .5rem;
            border: 1px solid #ddd;
            outline: none;
        }

        button {
            min-width: 80px;
            height: 36px;
            background-color: #214e98;
            border: 0;
            color: #fff;
        }

    }

    .tag {
        margin-top: .5rem;

        a {
            margin-right: .5rem;
            color: #999;
        }
    }
}

.club-hot {
    margin-top: 1rem;

    .hot-item {
        display: flex;
        justify-self: start;
        margin-bottom: 1rem;

        img {
            width: 48px;
            border-radius: 50%;
        }

        .info {
            margin-left: .5rem;
        }
    }
}
</style>
