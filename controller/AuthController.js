import validate from 'validate.js'
import util from '../util/util'
import svgCaptcha from 'svg-captcha'

class AuthController {

    // 登录
    async login(ctx) {
        let rule = {
            username: {
                type: "string",
                presence: true
            },
            password: {
                type: "string",
                presence: true
            },
            captcha: {
                type: "string",
                presence: true,
                length: { min: 4, max: 4 }
            }
        }
        let info = validate(ctx.request.body, rule)
        if (info) {
            util.failHasDesc(ctx, 2100, info)
            return
        }

        // 验证码校验
        let captcha = ctx.cookies.get('captcha')
        if (captcha == ctx.request.body.captcha.toLowerCase()) {
            let ret = await ctx.service.User.info();
            if (ret) {
                ctx.session.user = ret
                util.okHasInfo(ctx, ret)
            } else {
                util.failHasDesc(ctx, 2501, 'wrong account or password')
            }
        } else {
            util.failHasDesc(ctx, 2301, 'wrong captcha')
        }
    }

    // 注册
    async register(ctx) {
        let rule = {
            username: {
                type: "string",
                presence: true
            },
            password: {
                type: "string",
                presence: true
            },
            captcha: {
                type: "string",
                presence: true,
                length: { min: 4, max: 4 }
            }
        }
        let info = validate(ctx.request.body, rule)
        if (info) {
            util.failHasDesc(ctx, 2100, info)
            return
        }

        // 验证码校验
        let captcha = ctx.cookies.get('captcha')
        if (captcha == ctx.request.body.captcha.toLowerCase()) {
            info = await ctx.service.User.create();
            if (info) {
                util.okHasInfo(ctx, info);
            } else {
                util.failHasDesc(ctx, 5050, 'sign fail');
            }
        } else {
            util.failHasDesc(ctx, 2301, 'wrong captcha')
        }

    }

    // 忘记密码
    async forget(ctx) {
        // TODO 取登录用户
        let userId = 1
        let ret = await ctx.service.User.setSign(userId);
        if (ret) {
            util.ok(ctx);
        } else {
            util.failHasDesc(ctx, 5000, 'sign fail');
        }
    }

    // 获取验证码
    async captcha(ctx) {
        let captcha = svgCaptcha.create({ width: 150, height: 36 })
        if (captcha) {
            ctx.cookies.set('captcha', captcha.text.toLowerCase())
            // let key = `captcha_${captcha.text.toLowerCase()}`
            // ctx.redis.set(key, true)
            // ctx.redis.expire(key, 300)
            util.okHasInfo(ctx, captcha.data)
        } else {
            util.fail(ctx)
        }
    }

    async preview(ctx) {
        util.ok(ctx)
    }

    async upload(ctx) {
        let file = ctx.request.files.file
        let info = await util.upload(file)
        if(info) {
            util.okHasInfo(ctx, info)
        } else {
            util.fail(ctx)
        }
    }

    // 退出登录
    async logout(ctx) {
        ctx.session.user = null
        util.ok(ctx)
    }
}

module.exports = AuthController