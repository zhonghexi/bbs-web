<template>
<div class="detail">
    <Header />
    <div class="container">
        <a-row class="container" :gutter="16">
            <a-col :span="16">
                <div class="box">
                    <h1>{{topicInfo.title}}</h1>
                    <div class="author">
                        <div class="info clearfix">
                            <img :src="imgUrl + topicInfo.user.avatar">
                            <span class="text">
                                <cite>
                                    <a href="">{{topicInfo.user.nickname}}</a>
                                    <time>{{topicInfo.createAt}}</time>
                                </cite>
                                <mark>悬赏：<strong>20</strong>&nbsp;篱笆</mark>
                            </span>
                        </div>
                        <div class="track">
                            <a href="javascript:;" title="回复数">
                                <i class="iconfont">&#xe635;</i>
                                <span>{{topicInfo.replyCount}}</span>
                            </a>
                            <!-- <a href="javascript:;" title="浏览量">
                                <i class="iconfont">&#xe633;</i>
                                <span>200</span>
                            </a> -->
                        </div>
                    </div>
                    <div class="content" ref="detailViewer"></div>
                    <ul class="reply">
                        <li class="reply-item" v-for="item in replyList" :key="item.id">
                            <cite>
                                <router-link class="avatar" :to="'/user/collect?userId=' + item.user.id + '&username=' + item.user.username">
                                    <img :src="imgUrl + item.user.avatar">
                                </router-link>
                                <div class="user-info">
                                    <router-link :to="'/user/collect?userId=' + item.user.id + '&username=' + item.user.username">{{item.user.nickname}}</router-link>
                                    <time>{{item.createAt}}</time>
                                </div>
                            </cite>
                            <div class="reply-detail" v-html="item.detail"></div>
                            <div class="track">
                                <!-- <a>
                                    <i class="iconfont">&#xe753;</i>
                                    <span>100</span>
                                </a> -->
                                <a @click="showReply(item.user)">
                                    <i class="iconfont">&#xe635;</i>
                                    <span>回复</span>
                                </a>
                            </div>
                        </li>
                    </ul>
                    <div class="do-reply">
                        <div ref="toastuiEditor"></div>
                        <a-button type="danger" @click="onSubmit">提交回复</a-button>
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
                                <i class="iconfont">&#xe635;</i>&nbsp;{{item.relpy_count}}
                            </span>
                        </li>
                    </ul>
                </div>
                <div class="box">
                    <h2>
                        <span>
                            超级赞助商
                            <a-divider type="vertical" />
                            <router-link to="/topic/detail?id=1">我要加入</router-link>
                        </span>
                    </h2>
                    <ul class="advert">
                        <li v-for="item in advertList" :key="item.id">
                            <router-link :to="item.link">
                                <img :src="imgUrl + item.assets">
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
import 'codemirror/lib/codemirror.css'
import '@toast-ui/editor/dist/toastui-editor.css'
import Editor from '@toast-ui/editor'
import Viewer from '@toast-ui/editor/dist/toastui-editor-viewer'
import Footer from '@/components/footer.vue'

export default {
    name: 'Detail',
    components: {
        Header,
        Footer
    },
    data() {
        return {
            imgUrl: this.env.imgUrl,
            editor: null,
            viewer: null,
            replyList: [],
            topicInfo: {
                user: {}
            },
            rankList: [],
            advertList: []
        }
    },
    watch: {
        $route(to){
            console.log(to.path);
            this.getTopic();
        }
    },
    mounted() {
        this.editor = this.initEditor()
        this.getTopic();
        this.getReply();
        this.getRank();
        this.getAdvert();
    },
    methods: {
        initEditor(option = null) {
            if(!option) {
                option = {
                    el: this.$refs.toastuiEditor,
                    height: '200px',
                    initialEditType: 'wysiwyg',
                    previewStyle: 'vertical',
                    toolbarItems: [
                        'heading',
                        'hr',
                        'divider',
                        'image',
                        'link',
                        'divider',
                        'quote',
                        'code',
                        'codeblock'
                    ]
                }
            }

            return new Editor(option)
        },

        getTopic() {
                this.$http({
                    url: '/api/topic/getInfo',
                    method: 'get',
                    params: {
                        id: this.$route.query.id
                    }
                }).then(res => {
                    if(1100 == res.data.code) {
                        this.topicInfo = res.data.info
                        new Viewer({
                            el: this.$refs.detailViewer,
                            initialValue: res.data.info.detail
                        })
                    }
                })
        },

        getReply() {
            this.$http({
                url: '/api/reply/getList',
                method: 'get',
                params: {
                    page: 1,
                    pageSize: 50,
                    topicId: this.$route.query.id
                }
            }).then(res => {
                if(1200 == res.data.code) {
                    this.replyList = res.data.list
                }
            })
        },

        showReply(user) {
            let html = `@${user.nickname}&nbsp;`
            this.editor.setHtml(html)
        },

        getRank() {
            this.$http({
                url: '/api/topic/getList',
                method: 'get',
                params: {
                    page: 1,
                    pageSize: 10,
                    isRank: 1
                }
            }).then(res => {
                if(1200 == res.data.code) {
                    this.rankList = res.data.list
                }
            })
        },

        onSubmit() {
            let data = {
                topicId: this.topicInfo.id,
                detail: this.editor.getHtml()
            }
            this.$http({
                url: '/api/reply/setInfo',
                method: 'post',
                data: data
            }).then(res => {
                if(1000 == res.data.code) {
                    this.$message.success('回复提交成功！')
                    this.getReply()
                }
            })
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
                    this.advertList = res.data.list
                }
            })
        }
    }
}
</script>

<style lang="less" scoped>
.detail {
    background-color: #f2f2f2;

    .ant-row {
        margin-top: 1rem;
    }

    h1 {
        padding: 1rem;
    }

    .author {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0 1rem;

        .info {
            img {
                margin-right: 1rem;
                width: 48px;
                height: 48px;
                border-radius: 50%;
                float: left;
            }

            .text {
                float: left;

                time {
                    margin-left: .5rem;
                }

                mark {
                    display: block;
                    background-color: transparent;
                }
            }

        }

    }

    .content {
        padding: 2rem 1rem;
    }

}

.track {
    a {
        margin-right: 1rem;
        &:last-child {
            margin-right: 0;
        }

        span {
            margin-left: .25rem;
        }
    }
}

.reply {
    padding: 1rem;

    .reply-item {
        padding-top: 1rem;
        border-top: 1px dotted #ddd;

        cite {
            display: flex;
            justify-content: flex-start;

            a.avatar {
                float: left;

                img {
                    width: 48px;
                    margin-right: 1rem;
                }
            }

            .user-info {
                line-height: 24px;
                a {
                    display: block;
                }
            }
        }

        .reply-detail {
            margin: 1rem 0;
        }
    }
}

/deep/ .box .reply-detail h2 {
    border-bottom: 0;
}

.do-reply {
    padding: 1rem;

    .ant-btn-danger {
        margin-top: 1rem;
        background-color: #769912;
        border-color: #769912;
    }
}

.advert {
    padding: 1rem;

    li {
        margin-bottom: 1rem;

        &:last-child {
            margin-bottom: 0;
        }

        img {
            width: 100%;
        }
    }
}
</style>
