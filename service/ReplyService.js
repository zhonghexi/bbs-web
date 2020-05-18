import moment from 'moment'

class ReplyService {

    async list() {
        const {ctx, Sequelize} = this;
        // const Op = Sequelize.Op

        // ctx.model.topic.belongsTo(ctx.model.user)
        let param = ctx.query;
        let offset = (param.page - 1) * param.pageSize

        ctx.model.reply.belongsTo(ctx.model.user, {
            foreignKey: 'user_id',
            targetKey: 'userId'
        })
        
        let condition = {
            include: [
                {
                    model: ctx.model.user
                }
            ],
            // attributes: ['id', 'title', 'userId', 'createAt'],
            where: {
                status: 1
            },
            offset: offset,
            limit: Number(param.pageSize)
        }

        if(param.topicId) {
            condition.where.topicId = Number(param.topicId)
        }

        if(undefined != param.status) {
            condition.where.status = Number(param.status)
        }

        let total = 0, list = []
        let obj = await ctx.model.reply.findAndCountAll(condition)
        if (0 < obj.count) {
            total = obj.count
            obj.rows.forEach(e => {
                list.push(e);
            })
        }

        return {total: total, data: list}
    }

    async info() {
        const {ctx, Sequelize} = this;
        let param = ctx.query;

        ctx.model.reply.belongsTo(ctx.model.user, {
            foreignKey: 'user_id',
            targetKey: 'userId'
        })

        let condition = {
            include: [{
                model: ctx.model.user,
                left: true
            }],
            attributes: ['id', 'title', 'userId', 'detail', 'createAt', 'updateAt'],
            where: {
                id: Number(param.id)
            }
        }
        let info = await ctx.model.reply.findOne(condition)
        return info.dataValues
    }

    // 回帖
    async create() {
        const {ctx} = this
        let params = ctx.request.body
        let status = (undefined == params.status) ? 1 : params.sort
        let data = {
            userId: ctx.session.user.userId,
            topicId: params.topicId,
            detail: params.detail,
            status: status,
            createAt: moment().locale('zh-cn').format('YYYY-MM-DD HH:mm:ss')
        }
        return await ctx.model.reply.create(data)
    }
}

module.exports = ReplyService