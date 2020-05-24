import validate from 'validate.js';
import util from '../util/util';

class TopicController {

    // 列表
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
            util.failHasDesc(ctx, 2100, info)
            return
        }
        // ctx.redis.set("aa", "Jhone");
        let param = {}
        switch(ctx.query.scope) {
            case '1': // 仅限社区
                param.clubId = 2
                break
            case '2': // 仅限自己
                param.userId = 1
                break
        }
        let ret = await ctx.service.Topic.list(param);
        util.okHasList(ctx, ret.data, ret.total);
    }

    // 详情
    async getInfo(ctx) {
        let rule = {
            id: {
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

        let ret = await ctx.service.Topic.info();
        util.okHasInfo(ctx, ret);
    }

    // 新增|编辑
    async setInfo(ctx) {
        let rule = {
            id: {
                numericality: true
            },
            title: {
                presence: true
            },
            detail: {
                presence: true
            }
        }
        let params = ctx.request.body
        let info = validate(params, rule)
        if(info) {
            util.failHasDesc(ctx, 2100, info)
            return
        }

        let ret = false
        if (!params.id) {
            ret = await ctx.service.Topic.create();
        } else {
            ret = await ctx.service.Topic.update();
        }
        
        util.okHasInfo(ctx, ret);
    }

    async setSection(ctx) {
        let rule = {
            sectionId: {
                numericality: true
            }
        }
        let info = validate(ctx.query, rule)
        if(info) {
            util.failHasDesc(ctx, 2100, info)
            return
        }

        let ret = await ctx.service.Topic.section();
        if(ret) {
            util.ok(ctx)
        } else {
            util.fail(ctx)
        }
    }

    // 删除
    async delInfo(ctx) {
        let rule = {
            id: {
                numericality: true
            }
        }
        let info = validate(ctx.query, rule)
        if(info) {
            util.failHasDesc(ctx, 2100, info)
            return
        }
        let ret = await ctx.service.Topic.delete();
        if(ret) {
            util.ok(ctx)
        } else {
            util.fail(ctx)
        }
    }

}

module.exports = TopicController