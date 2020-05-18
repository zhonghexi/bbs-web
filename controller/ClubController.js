import validate from 'validate.js'
import util from '../util/util'

class ClubController {

    // 社区列表
    async getList(ctx) {
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
            util.failHasDesc(ctx, 2101, info)
            return
        }

        let ret = await ctx.service.Club.list()
        util.okHasList(ctx, ret.data, ret.total)
    }

    async getInfo(ctx) {
        let rule = {
            id: {
                presence: true,
                numericality: true
            }
        }
        let info = validate(ctx.query, rule)
        if(info) {
            util.failHasDesc(ctx, 2101, info)
            return
        }

        let ret = await ctx.service.Club.info()
        util.okHasInfo(ctx, ret)
    }

    // 热门社区-排行榜前10
    async getRank(ctx) {
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
            util.failHasDesc(ctx, 2101, info)
            return
        }

        let ret = await ctx.service.Club.rank()
        util.okHasList(ctx, ret.data, ret.total)
    }

    // 社区创建|提交申请
    async setInfo(ctx) {
        let rule = {
            name: {
                type: "string"
            }
        }
        let info = validate(ctx.request.body, rule)
        if(info) {
            util.failHasDesc(ctx, 2101, info)
            return
        }
        let cover = await util.upload(ctx.request.files.cover)
        let ret = await ctx.service.Club.create(cover)
        if(ret) {
            util.ok(ctx)
        } else {
            util.failHasDesc(ctx, 5010, 'already exists')
        }
    }

    // 处理申请
    async optApply(ctx) {
        let rule = {
            id: {
                presence: true,
                numericality: true
            },
            status: {
                presence: true,
                numericality: true
            }
        }
        let info = validate(ctx.query, rule)
        if(info) {
            util.failHasDesc(ctx, 2101, info)
            return
        }

        let ret = await ctx.service.Club.optApply()
        if(ret) {
            util.ok(ctx)
        } else {
            util.fail(ctx)
        }
    }

    // 社区成员
    async member(ctx) {
        let rule = {
            id: {
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
            util.failHasDesc(ctx, 2101, info)
            return
        }

        let ret = await ctx.service.Club.member()
        if(ret) {
            util.okHasList(ctx, ret.data, ret.total)
        } else {
            util.fail(ctx)
        }
    }
}

module.exports = ClubController