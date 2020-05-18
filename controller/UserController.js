import validate from 'validate.js';
import util from '../util/util';

class UserController {

    // 回贴周榜
    async weekRank(ctx) {
        let rule = {
            page: {
                presence: true,
                numericality: true
            },
            pageSize: {
                presence: true,
                numericality: true
            }
        }
        let info = validate(ctx.query, rule)
        if(info) {
            util.failHasDesc(ctx, 2100, info)
            return
        }
        // ctx.redis.set("aa", "Jhone");

        let ret = await ctx.service.User.list();
        util.okHasList(ctx, ret.data, ret.total);
    }

    // 获取本月签到
    async getSign(ctx) {
        // TODO 取登录用户
        let userId = 1
        let info = await ctx.service.User.getSign(userId);
        if(info) {
            util.okHasInfo(ctx, info);
        } else {
            util.failHasDesc(ctx, 5050, 'sign fail');
        }
    }

    async setSign(ctx) {
        // TODO 取登录用户
        let userId = ctx.session.user.userId
        let ret = await ctx.service.User.setSign(userId);
        if(ret) {
            util.ok(ctx);
        } else {
            util.failHasDesc(ctx, 5000, 'sign fail');
        }
    }

    // 收藏列表
    async collect(ctx) {
        let rule = {
            userId: {
                presence: true,
                numericality: true
            },
            page: {
                presence: true,
                numericality: true
            },
            pageSize: {
                presence: true,
                numericality: true
            }
        }
        let info = validate(ctx.query, rule)
        if(info) {
            util.failHasDesc(ctx, 2100, info)
            return
        }

        let ret = await ctx.service.User.collect();
        util.okHasList(ctx, ret.data, ret.total);
    }

    // 加入收藏
    async doCollect(ctx) {
        let rule = {
            topicId: {
                presence: true,
                numericality: true
            }
        }
        let info = validate(ctx.request.body, rule)
        if(info) {
            util.failHasDesc(ctx, 2100, info)
            return
        }

        let ret = await ctx.service.User.doCollect();
        if(ret) {
            util.ok(ctx);
        } else {
            util.failHasDesc(ctx, 5000, 'collect fail');
        }
    }

    async getInfo(ctx) {
        let rule = {
            username: {
                presence: true
            }
        }
        let info = validate(ctx.request.body, rule)
        if(info) {
            util.failHasDesc(ctx, 2100, info)
            return
        }

        let ret = await ctx.service.User.info();
        util.okHasInfo(ctx, ret);
    }

}

module.exports = UserController