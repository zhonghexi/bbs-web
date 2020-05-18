import validate from 'validate.js';
import util from '../util/util';

class ReplyController {

    async getList(ctx) {
        let rule = {
            topicId: {
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
            util.FailHasDesc(ctx, 2101, info)
            return
        }

        let ret = await ctx.service.Reply.list();
        util.okHasList(ctx, ret.data, ret.total);
    }

    async setInfo(ctx) {
        let rule = {
            detail: {
                presence: true
            }
        }
        let info = validate(ctx.request.body, rule)
        if(info) {
            util.failHasDesc(ctx, 2101, info)
            return
        }

        let ret = await ctx.service.Reply.create();
        if(ret) {
            util.ok(ctx);
        } else {
            util.fail(ctx)
        }
    }
}

module.exports = ReplyController;