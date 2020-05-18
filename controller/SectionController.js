import validate from 'validate.js';
import util from '../util/util';

class SectionController {

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
            util.FailHasDesc(ctx, 2101, info)
            return
        }
        // ctx.redis.set("aa", "Jhone");

        let ret = await ctx.service.Section.list();
        util.okHasList(ctx, ret.data, ret.total);
    }
    
}

module.exports = SectionController