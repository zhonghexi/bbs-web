<template>
<div class="club">
    <Header msg="Welcome to Your Vue.js App" />
    <div class="container">
        <a-row :gutter="16">
            <a-col :span="16">
                <div class="club-item" v-for="item in clubList" :key="item.id">
                    <a class="club-count">
                        <i class="iconfont">&#xe675;</i>
                        <span>{{item.topicCount}}</span>
                    </a>
                    <div class="club-info">
                        <div class="club-name">
                            <router-link :to="'/club/detail?id=' + item.id">{{item.name}}</router-link>
                            <span class="star">
                                <i class="iconfont" v-for="n in item.starCount" :key="'F' + n">&#xe66a;</i>
                                <i class="iconfont" v-for="n in (5 - item.starCount)" :key="'E' + n">&#xe669;</i>
                            </span>
                        </div>
                        <div class="club-admin">
                            <a class="avatar" href="">
                                <img :src="imgUrl + item.user.avatar">
                                <cite>{{item.user.nickname}}</cite>
                            </a>
                            <a class="apply" href="">
                                <i class="iconfont">&#xe615;</i>&nbsp;申请加入
                            </a>
                        </div>
                        <p>{{item.brief}}</p>
                    </div>
                </div>
                <a-form class="btn-club" :form="form">
                    <a class="more" v-on:click="setPage">更多社区</a>
                    <a class="create" href="javascript:;" v-on:click="setClub">创建社区</a>
                    <a-modal title="创建社区" v-model="visible" @ok="setClub" okText="提交申请" cancelText="取消申请">
                        <a-form-item class="upload" label="社区封面">
                            <a-upload v-decorator="[
                                'cover',
                                { rules: [{ required: true, message: 'Please input your name' }] },
                                ]" list-type="picture-card" :show-upload-list="false" action="https://www.mocky.io/v2/5cc8019d300000980a055e76" :before-upload="beforeUpload" @change="handleChange">
                                <img v-if="imageUrl" :src="imageUrl" alt="avatar" />
                                <div v-else>
                                    <a-icon :type="loading ? 'loading' : 'plus'" />
                                    <div class="ant-upload-text">
                                        Upload
                                    </div>
                                </div>
                            </a-upload>
                            <span>
                                <p>图片尺寸1：1最大不超过800*800，不小于100*100</p>
                                <p>为了通过率避免上传低俗不雅图片</p>
                            </span>
                        </a-form-item>
                        <a-form-item label="社区名称">
                            <a-input v-decorator="[
                                'name',
                                { rules: [{ required: true, message: '请输入社区名称' }] },
                                ]" />
                        </a-form-item>
                        <a-form-item label="社区简介">
                            <a-input v-decorator="[
                                'brief',
                                { rules: [{ required: true, message: '请输入社区简介' }] },
                                ]" />
                        </a-form-item>
                        <a-form-item label="申请理由">
                            <a-textarea v-decorator="[
                                'remark',
                                { rules: [{ required: true, message: '请填写申请理由' }] },
                                ]" :rows="4" />
                        </a-form-item>
                    </a-modal>
                </a-form>
            </a-col>
            <a-col :span="8">
                <form class="club-filter" @submit="e => {e.preventDefault();search()}">
                    <div class="form-item">
                        <label><strong>{{total}}</strong>&nbsp;个社区</label>
                        <div class="input-group">
                            <input name="keyword" v-model="keyword" type="text">
                            <button type="submit">搜索</button>
                        </div>
                    </div>
                    <div class="tag">
                        <a @click="search('百度')">百度</a>
                        <a @click="search('阿里巴巴')">阿里巴巴</a>
                        <a @click="search('华为')">华为</a>
                    </div>
                </form>
                <div class="club-hot">
                    <h2>热门社区</h2>
                    <div class="hot-item" v-for="item in rankList" :key="item.id">
                        <router-link :to="'/club/detail?id=' + item.id">
                            <img :src="imgUrl + item.cover">
                        </router-link>
                        <div class="info">
                            <router-link :to="'/club/detail?id=' + item.id">
                                <h3>{{item.name}}</h3>
                            </router-link>
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
            visible: false,
            clubList: [],
            page: 1,
            pageSize: 10,
            keyword: null,
            rankList: [],
            loading: false,
            imageUrl: '',
            form: this.$form.createForm(this),
            imgUrl: this.env.imgUrl,
            total: 0
        }
    },
    mounted() {
        this.getClub()
        this.getRank()
    },
    methods: {
        // 社区列表
        getClub() {
            this.$http({
                url: '/api/club/getList',
                method: 'get',
                params: {
                    page: this.page,
                    pageSize: this.pageSize
                }
            }).then(res => {
                if (1200 == res.data.code) {
                    this.clubList = this.clubList.concat(res.data.list)
                    this.total = res.data.total
                }
            })
        },

        // 更多社区
        setPage() {
            this.page += 1
            this.getClub()
        },

        // 创建社区
        setClub() {
            if (!this.visible) {
                this.visible = true
                return
            }

            this.form.validateFields((err, val) => {
                if(!err) {
                    let formData = new FormData()
                    formData.append('name', val.name)
                    formData.append('brief', val.brief)
                    formData.append('cover', val.cover.file.originFileObj)
                    formData.append('remark', val.remark)
                    this.$http({
                        url: '/api/club/setInfo',
                        method: 'post',
                        data: formData
                    }).then(res => {
                        switch(res.data.code) {
                            case 1000:
                                this.visible = false
                                this.$message.success('提交申请成功，请耐心等待审核！')
                                break
                            case 5010:
                                this.$message.error(`"${val.name}"已存在，请更换一个名称再试！`)
                                break
                            case 4005:
                                this.$router.push('/auth/login')
                        }
                    })
                }
            })
        },
        // 搜索
        search(keyword = null) {
            if(undefined != keyword) {
                this.keyword = keyword
            }
            this.$http({
                url: '/api/club/getList',
                method: 'get',
                params: {
                    page: this.page,
                    pageSize: this.pageSize,
                    name: this.keyword
                }
            }).then(res => {
                if (1200 == res.data.code) {
                    this.clubList = res.data.list
                } else {
                    this.clubList = []
                }
            })
        },

        // 社区排行
        getRank() {
            this.$http({
                url: '/api/club/getRank',
                method: 'get',
                params: {
                    page: 1,
                    pageSize: 10
                }
            }).then(res => {
                if (1200 == res.data.code) {
                    this.rankList = res.data.list
                }
            })
        },

        handleChange(info) {
            if (info.file.status === 'uploading') {
                this.loading = true;
                return;
            }
            if (info.file.status === 'done') {
                // Get this url from response in real world.
                this.getBase64(info.file.originFileObj, imageUrl => {
                    this.imageUrl = imageUrl;
                    this.loading = false;
                });
            }
        },

        beforeUpload(file) {
            const isJpgOrPng = file.type === 'image/jpeg' || file.type === 'image/png';
            if (!isJpgOrPng) {
                this.$message.error('You can only upload JPG file!');
            }
            const isLt2M = file.size / 1024 / 1024 < 2;
            if (!isLt2M) {
                this.$message.error('Image must smaller than 2MB!');
            }
            return isJpgOrPng && isLt2M;
        },

        getBase64(img, callback) {
            const reader = new FileReader();
            reader.addEventListener('load', () => callback(reader.result));
            reader.readAsDataURL(img);
        }
    }
}
</script>

<style lang="less" scoped>
.club-item {
    display: flex;
    justify-self: start;
    padding: 1rem 1rem 0;
    border-bottom: 1px dotted #ddd;

    &:last-child {
        border-bottom: 0;
    }

    .club-count {
        margin-right: 1rem;
        width: 60px;
        height: 52px;
        text-align: center;
        border: 1px solid #999;
        border-radius: 4px;

        span {
            display: block;
            font-size: 1rem;
            font-weight: 600;
        }
    }

    .club-info {
        .club-name {
            font-size: 1.25rem;

            .star {
                margin-left: 1rem;

                .iconfont {
                    font-size: 1.25rem;
                }
            }
        }

        .club-admin {
            padding: .5rem 0;

            a {
                color: #777;
            }

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
        }

        p {
            color: #999;
        }
    }
}

.btn-club {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 80px;

    a {
        margin-left: 1rem;
        width: 100px;
        line-height: 2.25rem;
        color: #fff;
        text-align: center;
        background-color: #ddd;
        border-radius: 4px;

        &:first-child {
            margin-left: 0;
        }
    }

    a.more {
        color: #333;
        border: 1px solid #214e98;
        background-color: transparent;
    }

    a.create {
        background-color: #214e98;
    }
}

/deep/ .ant-form-item-children {
    display: flex;
    justify-content: flex-start;
    .ant-upload-picture-card-wrapper {
        width: 112px;
        margin-right: 1rem;
    }
}

.club-filter {
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

.ant-upload {
    width: 100px;
    overflow: hidden;
    img {
        width: 80px;
    }
}

</style>
