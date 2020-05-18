<template>
<div class="shortcut">
    <div class="container">
        <nav>
            <router-link v-for="item in sectionList" :key="item.id" :to="'/section?id='+item.id" exact>{{item.name}}</router-link>
            <a-divider type="vertical" />
            <router-link to="/topic/publish">我发表的贴</router-link>
            <router-link to="/topic/publish">我收藏的贴</router-link>
        </nav>
        <form class="filter">
            <!-- <div class="input-filter">
                <input name="keyword" type="text">
                <i class="iconfont">&#xe63f;</i>
            </div> -->
            <router-link to="/topic/publish">发表新贴</router-link>
        </form>
    </div>
</div>
</template>

<script>
export default {
    name: 'Shortcut',
    props: {
        keyword: {
            type: String,
            default: null
        }
    },
    data() {
        return {
            sectionList: []
        }
    },
    mounted() {
        this.getSection()
    },
    methods: {
        getSection() {
            this.$http({
                method: 'get',
                url: 'api/section/getList',
                params: {
                    page: 1,
                    pageSize: 10,
                    parentId: 1
                }
            }).then(res => {
                if (1200 == res.data.code) {
                    this.sectionList = res.data.list
                } else {
                    this.sectionList = []
                }
            })
        }
    }
}
</script>

<style lang="less" scoped>
.shortcut {
    height: 50px;
    margin-bottom: 1rem;
    background-color: #fff;

    .container {
        display: flex;
        justify-content: space-between;
        align-items: center;
        height: 100%;

        nav a {
            margin-right: 1.5rem;
            color: #666;

            &:hover {
                color: #769912;
            }
        }

        a.active {
            color: #769912;
        }
    }

    .filter {
        clear: both;

        a {
            display: block;
            width: 90px;
            line-height: 34px;
            margin-left: 1rem;
            float: right;
            text-align: center;
            color: #fff;
            border: 0;
            background-color: #214e98;
            border-radius: 4px;
        }
    }

    .input-filter {
        float: left;
        position: relative;

        input {
            padding-left: .5rem;
            width: 260px;
            height: 36px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        i {
            position: absolute;
            top: 0;
            right: 0;
            font-size: 1.5rem;
            cursor: pointer;
        }
    }
}
</style>
