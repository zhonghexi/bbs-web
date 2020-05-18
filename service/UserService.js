import moment from 'moment'

class UserService {

    async list() {
        const { ctx, Sequelize } = this

        let param = ctx.query
        let offset = (param.page - 1) * param.pageSize

        let condition = {
            attributes: ['userId', 'nickname', 'avatar', 'replyCount', 'topicCount'],
            offset: offset,
            order: [],
            limit: Number(param.pageSize)
        }

        if ('reply' == param.orderBy) {
            condition.order.push(['reply_count', 'DESC'])
        } else {
            condition.order.push(['userId', 'DESC'])
        }

        let total = 0, list = []
        let obj = await ctx.model.user.findAndCountAll(condition)
        if (0 < obj.count) {
            total = obj.count
            obj.rows.forEach(e => {
                list.push(e);
            });
        }

        return { total: total, data: list }
    }

    async info() {
        const { ctx } = this
        let param = ctx.request.body

        let condition = {
            attributes: ['userId', 'username', 'nickname', 'brief', 'avatar', 'replyCount', 'topicCount', 'liba'],
            where: {
                'username': param.username
            }
        }
        if(!!param.password) {
            condition.where.password = param.password
        }
        let ret = await ctx.model.user.findOne(condition)
        if (!ret) {
            return false
        }
        
        return ret.dataValues
    }

    /**
     * 获取签到
     * @param {*} userId 
     */
    async getSign(userId) {
        const { ctx } = this

        let condition = {
            where: {
                'userId': userId
            },
            order: [
                ['cycle', 'DESC']
            ]
        }
        let ret = await ctx.model.sign.findOne(condition)
        if (!ret) {
            return false
        }
        let date = moment().endOf('month').format('YYYY-MM-DD')
        if (date != ret.dataValues.cycle) {
            return false
        }
        return ret.dataValues
    }


    /**
     * 更新签到
     * @param {*} userId 
     */
    async setSign(userId) {
        const { ctx, Sequelize } = this

        let condition = {
            where: {
                'userId': userId
            },
            order: [
                ['cycle', 'DESC']
            ]
        }
        let data = {}
        let ret = await ctx.model.sign.findOne(condition)
        if (ret) {
            let currTime = new Date(moment().format('YYYY-MM-DD')).getTime()
            let cycleTime = new Date(ret.dataValues.cycle).getTime()
            // 当月有签到
            if (currTime <= cycleTime) {
                let arr = ret.dataValues.mark.split(',')
                // 判断当天是否已经签到
                if (arr.pop() == moment().date()) {
                    return false
                }
                data = {
                    'days': ret.dataValues.days + 1,
                    'mark': ret.dataValues.mark + ',' + moment().date()
                }
                let where = {
                    where: {
                        'userId': userId,
                        'cycle': moment().endOf('month').format('YYYY-MM-DD')
                    }
                }
                return await ctx.model.sign.update(data, where)
            }
        }
        // 当月无签到
        data = {
            cycle: moment().endOf('month').format('YYYY-MM-DD'),
            userId: userId,
            days: 1,
            mark: moment().date()
        }
        return await ctx.model.sign.create(data)
    }

    // 注册
    async create() {
        const {ctx, Sequelize} = this
        let param = ctx.request.body;

        let condition = {
            where: {
                'username': param.username
            }
        }
        let ret = await ctx.model.user.findOne(condition)
        if(ret) {
            return false
        }

        let avatar = '';
        if(undefined == param.avatar) {
            avatar = 'assets/avatar/' + parseInt(10 * Math.random()) + '.jpg'
        } else {
            avatar = params.avatar
        }

        let data = {
            username: param.username,
            nickname: param.nickname,
            password: param.password,
            avatar: avatar,
            replyCount: 0,
            topicCount: 0
        }
        return await ctx.model.user.create(data)
    }

    async collect() {
        const {ctx, Sequelize} = this
        let param = ctx.query

        let where = "WHERE b.`user_id`=" + Number(param.userId)
        // 统计条数
        let sql = "SELECT COUNT(*) cnt FROM `topic` a RIGHT JOIN `user_has_topic` b ON b.`topic_id`=a.`id`" + where
        let ret = await ctx.sequelize.query(sql, { replacements: ['active'], type: ctx.sequelize.QueryTypes.SELECT });
        let total = ret[0].cnt;
        // 获取数据
        sql = "SELECT a.* FROM `topic` a RIGHT JOIN `user_has_topic` b ON b.`topic_id`=a.`id`" + where + " ORDER BY a.`id` DESC"
        ret = await ctx.sequelize.query(sql, { replacements: ['active'], type: ctx.sequelize.QueryTypes.SELECT });
        return {total: total, data: ret}
    }

    // 加入收藏
    async doCollect() {
        const {ctx} = this
        let param = ctx.request.body

        let condition = {
            where: {
                'topic_id': param.topicId,
                'user_id': ctx.session.user.userId
            }
        }
        let ret = await ctx.model.userHasTopic.findOne(condition)
        if(ret) {
            return false
        }

        let data = {
            topicId: param.topicId,
            userId: ctx.session.user.userId
        }
        return await ctx.model.userHasTopic.create(data)
    }
}

module.exports = UserService