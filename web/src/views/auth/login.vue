<template>
<div class="login">
    <Header />
    <div class="auth">
        <div class="container">
            <div class="box">
                <a-form :form="form" @submit="onSubmit">
                    <a-form-item>
                        <a-input v-decorator="[
                            'username', 
                            { rules: [
                                { required: true, message: '请输入正确的账号!' }
                            ]}
                        ]" placeholder="请输入账号" />
                    </a-form-item>
                    <a-form-item>
                        <a-row class="captcha" :gutter="8">
                            <a-col :span="12">
                                <a-input v-decorator="[
                                'captcha',
                                { rules: [
                                    { required: true, message: '请输入正确的验证码!' }
                                ] },
                            ]" />
                            </a-col>
                            <a-col :span="12">
                                <a v-on:click="getCaptcha" v-html="captcha" title="点击刷新"></a>
                            </a-col>
                        </a-row>
                    </a-form-item>
                    <a-form-item>
                        <a-input v-decorator="[
                            'password', { rules: [
                                { required: true, message: '请输入正确的密码!' }
                            ] }
                        ]" type="password" placeholder="密码" />
                    </a-form-item>
                    <a-button type="primary" html-type="submit">登录</a-button>
                </a-form>
            </div>
        </div>
    </div>
    <Footer />
</div>
</template>

<script>
import Header from '@/components/header.vue'
import Footer from '@/components/footer.vue'
import crypto from 'crypto-js'

export default {
    name: 'Login',
    components: {
        Header,
        Footer
    },
    data() {
        return {
            form: this.$form.createForm(this),
            captcha: null
        }
    },
    mounted() {
        this.getCaptcha()
    },
    methods: {
        getCaptcha() {
            this.$http({
                url: '/api/auth/captcha',
                method: 'get'
            }).then(res => {
                if (1100 == res.data.code) {
                    this.captcha = res.data.info
                }
            })
        },

        onSubmit(e) {
            e.preventDefault()

            this.form.validateFields((err, values) => {
                if (!err) {
                    let data = {
                        username: values.username,
                        password: crypto.MD5(values.password).toString(),
                        captcha: values.captcha
                    }
                    this.$http({
                        url: '/api/auth/login',
                        method: 'post',
                        data: data
                    }).then(res => {
                        switch(res.data.code) {
                            case 1100:
                                localStorage.setItem('userInfo', JSON.stringify(res.data.info))
                                this.$message.success('登录成功')
                                this.$router.push('/')
                                break
                            case 2501:
                                this.$message.error('账号或密码错误')
                                break
                            case 2301:
                                this.$message.error('验证码错误')
                                break
                        }
                    })
                }
            });
        }
    }
}
</script>

<style lang="less" scoped>
.auth {
    background-image: url("../../assets/images/e7055d0c.jpg");
    background-repeat: no-repeat;
    background-size: 100%;

    .container {
        display: flex;
        justify-content: flex-end;
        align-items: center;
        min-height: 580px;
    }

    .box {
        padding: 2rem 1rem;
        width: 360px;
        border-radius: 4px;
    }

    .captcha {
        display: flex;
        align-items: center;
    }
}

footer {
    margin-top: 0;
}
</style>
