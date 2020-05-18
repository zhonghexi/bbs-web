import validate from 'validate.js'
import util from '../util/util'

class AdvertController {

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
            util.failHasDesc(ctx, 2101, info)
            return
        }

        let ret = await ctx.service.Advert.list()
        util.okHasList(ctx, ret.data, ret.total)
    }
}

module.exports = AdvertController