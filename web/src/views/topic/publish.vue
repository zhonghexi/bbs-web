<template>
<div class="publish">
    <Header />
    <div class="content">
        <div class="topic-menu">
            <div class="head">
                <a @click="showTopic()">
                    <i class="iconfont">&#xe6a2;</i>新建帖子
                    <!-- <span>新建帖子</span> -->
                </a>
            </div>
            <div class="body">
                <a class="m-item" v-bind:class="{active: (0 == activeInfo)}" @click="getTopic()">
                    <i class="iconfont">&#xe6fb;</i>
                    <span>最新帖子</span>
                </a>
                <router-link class="m-item" to="/user/collect">
                    <i class="iconfont">&#xe668;</i>
                    <span>我的收藏</span>
                </router-link>
                <div class="s-menu">
                    <a href="javascript:;">
                        <i class="iconfont">&#xe650;</i>
                        <span>默认版块</span>
                        <!-- <i class="iconfont">&#xe6aa;</i> -->
                    </a>
                    <a class="m-item" v-for="item in sectionList" :key="item.id" @click="getTopic({sectionId: item.id})" v-bind:class="{active: (item.id == activeInfo)}">{{item.name}}</a>
                </div>
                <a class="m-item" v-bind:class="{active: (-1 == activeInfo)}" @click="getTopic({flag: -1})">
                    <i class="iconfont">&#xe699;</i>
                    <span>回收站</span>
                </a>
            </div>
        </div>
        <div class="topic-list">
            <form class="filter" @submit="onSearch">
                <a class="iconfont" title="返回上级">&#xe7e5;</a>
                <span class="input-item">
                    <i class="iconfont">&#xe63f;</i>
                    <input type="text" v-model="keyword" placeholder="搜索...">
                </span>
                <a class="iconfont" title="排列切换">&#xe658;</a>
            </form>
            <ul class="topic-list">
                <li v-for="(item, index) in topicList" :key="item.id" @click="showTopic(index)">
                    <h3>
                        <span class="title">{{item.title}}</span>
                        <span class="active">
                            <a class="iconfont" title="分享">&#xe642;</a>
                            <a class="iconfont" @click="delTopic(item.id)" title="删除">&#xe699;</a>
                        </span>
                    </h3>
                    <div class="detail" v-html="item.detail"></div>
                    <div class="aux">
                        <time>{{item.createAt}}</time>
                    </div>
                </li>
            </ul>
        </div>
        <div class="topic-info">
            <div class="head">
                <input name="title" type="text" v-model="topicInfo.title">
                <span class="operate">
                    <button type="button" v-on:click="setTopic()">保存</button>
                    <a class="iconfont" title="分享">&#xe642;</a>
                    <a class="iconfont" title="预览">&#xe633;</a>
                    <a-dropdown :trigger="['click']">
                        <a class="iconfont" @click="e => e.preventDefault()" title="公布范围">&#xe7ce;</a>
                        <a-menu slot="overlay">
                            <a-menu-item>
                                <a href="javascript:;">不作限制</a>
                            </a-menu-item>
                            <a-menu-item>
                                <a href="javascript:;">仅限社区</a>
                            </a-menu-item>
                            <a-menu-item>
                                <a href="javascript:;">仅限自己</a>
                            </a-menu-item>
                        </a-menu>
                    </a-dropdown>
                    <a class="more">
                        <i class="iconfont">&#xe6ad;</i>
                    </a>
                </span>
            </div>
            <div class="body">
                <div ref="toastuiEditor"></div>
            </div>
        </div>
    </div>
</div>
</template>

<script>
import Header from '@/components/header.vue'
import 'codemirror/lib/codemirror.css'
import '@toast-ui/editor/dist/toastui-editor.css'
import Editor from '@toast-ui/editor'

export default {
    name: 'Publish',
    components: {
        Header,
    },
    data() {
        return {
            editor: null,
            sectionList: [],
            topicList: [],
            topicInfo: {},
            activeInfo: 0,
            keyword: null
        }
    },
    mounted() {
        this.editor = this.initEditor()
        this.getSection()
        this.getTopic()

        // let toolbar = this.editor.getUI().getToolbar()
    },
    methods: {
        imageUpload(file) {
            return new Promise((resolve, reject) => {
                let formData = new FormData()
                formData.append('file', file)
                this.$http({
                    url: '/api/auth/upload',
                    method: 'post',
                    data: formData
                }).then(res => {
                    if (1100 == res.data.code) {
                        resolve(res.data.info)
                    } else {
                        reject(res.data.desc)
                    }
                })
            })
        },

        initEditor() {
            let option = {
                el: this.$refs.toastuiEditor,
                height: '100%',
                initialEditType: 'wysiwyg',
                previewStyle: 'vertical',
                hooks: {
                    addImageBlobHook: (blob, callback) => {
                        let img = this.imageUpload(blob)
                        img.then(res => {
                            callback(this.env.imgUrl + res, 'alt text')
                        })
                    }
                }
            }
            return new Editor(option)
        },

        getSection() {
            this.$http({
                url: '/api/section/getList',
                method: 'get',
                params: {
                    page: 1,
                    pageSize: 10,
                    parentId: 1
                }
            }).then(res => {
                if (1200 == res.data.code) {
                    this.sectionList = res.data.list
                }
            })
        },

        onSearch(e) {
            e.preventDefault()
            this.getTopic({kw: this.keyword})
        },

        getTopic(params = {}) {
            this.activeInfo = 0
            if(params.sectionId) {
                this.activeInfo = params.sectionId
            }

            if(params.flag) {
                this.activeInfo = -1
            }
            
            this.topicList = []
            this.topicInfo = {}
            this.editor.setHtml(null)
            params = Object.assign({page: 1, pageSize: 50}, params)
            this.$http({
                url: '/api/topic/getList',
                method: 'get',
                params: params
            }).then(res => {
                if (1200 == res.data.code) {
                    this.topicList = res.data.list
                    if(0 < this.topicList.length) {
                        this.topicInfo = this.topicList[0]
                        this.editor.setHtml(this.topicInfo.detail)
                    }
                }
            })
        },

        setTopic() {
            let data = {
                title: this.topicInfo.title,
                detail: this.editor.getHtml(),
                sectionId: this.topicInfo.sectionId,
                scope: this.topicInfo.scope
            }
            if (this.topicInfo) {
                data.id = this.topicInfo.id
            }
            this.$http({
                url: '/api/topic/setInfo',
                method: 'post',
                data: data
            }).then(res => {
                if (1100 == res.data.code) {
                    this.$message.success('发布成功')
                } else {
                    this.$message.error('fafa')
                }
            })
        },

        showTopic(idx = null) {
            if(undefined != idx) {
                this.topicInfo = this.topicList[idx]
                this.editor.setHtml(this.topicInfo.detail)
            } else {
                this.topicInfo = {
                    title: '无标题帖子',
                    detail: null
                }
                this.editor.setHtml(null)
            }
            
        },

        // 删除帖子
        delTopic(id) {
            this.$http({
                url: '/api/topic/delete',
                method: 'get',
                params: {
                    id: id
                }
            }).then(res => {
                if (1000 == res.data.code) {
                    this.$message.success('删除成功')
                }
            })
        }
    }
}
</script>

<style lang="less" scoped>
.publish {
    height: 100%;
    overflow-y: auto;

    .ant-row {
        height: calc(100% - 56px);

        .ant-col {
            height: 100%;
            border-right: 1px solid #ddd;

            &:last-child {
                border-right: 0;
            }

            &:nth-child(2) {
                background-color: #fff;
            }
        }
    }

    .content {
        display: flex;
        justify-content: flex-start;
        height: calc(100% - 60px);
    }

}

.topic-menu {
    width: 260px;
    background-color: #f2f2f2;
    border-right: 1px solid #ddd;

    .head {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 60px;

        i {
            font-weight: 700;
            margin-right: .5rem;
        }

    }

    .body {
        border-top: 1px solid #ddd;

        a {
            display: block;
            position: relative;
            line-height: 36px;

            i {
                &:first-child {
                    position: absolute;
                    left: 16px;
                }

                &:last-child {
                    position: absolute;
                    right: 16px;
                }
            }

            span {
                margin-left: 40px;
            }
            &.active {
                color: #fff;
                background-color: #214e98;
            }
        }

        .s-menu {
            .m-item {
                padding-left: 40px;
            }
        }
    }

}

.topic-list {
    width: 360px;
    // border-left: 1px solid #ddd;

    .filter {
        display: flex;
        justify-content: center;
        align-items: center;
        padding: 0 1rem;
        height: 60px;

        .input-item {
            flex: 1;
            position: relative;
            margin: 0 1rem;

            i {
                position: absolute;
                top: 6px;
                left: .5rem;
            }

            input {
                width: 100%;
                height: 36px;
                padding-left: 2rem;
                border: 1px solid #ddd;
                border-radius: 8px;
                outline: none;
            }
        }

    }

    ul {
        overflow-y: auto;
        height: calc(100% - 60px);
        background-color: #fff;
        border-top: 1px solid #ddd;

        li {
            padding: 1rem;
            border-bottom: 1px solid #ddd;
            -webkit-user-select: none;
            -moz-user-select: none;

            &:hover {
                background-color: #eee;

                .active {
                    display: block;
                }
            }

            h3 {
                display: flex;
                height: 28px;

                .title {
                    overflow: hidden;
                    white-space: nowrap;
                    text-overflow: ellipsis;
                }

                .active {
                    display: none;

                    a {
                        margin-left: .5rem;
                    }
                }
            }

            .detail {
                margin-bottom: 1rem;
                max-height: 60px;
                overflow: hidden;
                text-overflow: ellipsis;
            }
        }
    }
}

.topic-info {
    flex: 1;
    height: 100%;

    .head {
        display: flex;
        justify-content: space-between;
        align-items: center;
        height: 60px;
        border-left: 1px solid #ddd;
        border-right: 1px solid #ddd;
        background-color: #fff;

        input {
            flex: 1;
            line-height: 56px;
            padding: 0 1rem;
            border: 0;
            background-color: transparent;
            outline: none;
            font-size: 1.25rem;
            font-weight: 600;
        }

        button {
            padding: 4px 16px;
            background-color: transparent;
            border: 1px solid #214e98;
            border-radius: 4px;
            color: #214e98;
        }

        .operate {
            min-width: 180px;

            a {
                margin-left: 1rem;
            }
        }
    }

    .body {
        height: calc(100% - 60px);
    }
}
</style>
