import moment from 'moment'

class TopicService {

    async list(param = {}) {
        const {ctx, Sequelize} = this;
        const Op = Sequelize.Op

        param = Object.assign(param, ctx.query);
        let offset = (param.page - 1) * param.pageSize

        ctx.model.topic.belongsTo(ctx.model.user, {
            foreignKey: 'userId',
            targetKey: 'userId'
        })

        ctx.model.topic.belongsTo(ctx.model.section, {
            foreignKey: 'sectionId',
            targetKey: 'id'
        })
        
        let condition = {
            include: [
                {
                    model: ctx.model.user
                },
                {
                    model: ctx.model.section
                }
            ],
            attributes: ['id', 'title', 'detail', 'userId', 'sectionId', 'clubId', 'scope', 'replyCount', 'createAt'],
            where: {
                flag: 2
            },
            order: [
                ['id', 'DESC']
            ],
            offset: offset,
            limit: Number(param.pageSize)
        }

        if(!!param.userId) {
            condition.where.user_id = Number(param.userId)
        } else {
            if(!!param.clubId) {
                condition.where.club_id = param.clubId
                condition.where.scope = {[Op.le]: 1}
            } else {
                condition.where.scope = 0
            }
        }
        
        if(undefined != param.flag) {
            condition.where.flag = Number(param.flag)
        }

        if(undefined != param.isTop) {
            condition.where.is_top = Number(param.isTop)
        }

        if(undefined != param.isRank) {
            condition.order = [
                ['reply_count', 'DESC']
            ]
        }

        if(undefined != param.sectionId) {
            condition.where.section_id = Number(param.sectionId)
        }

        let total = 0, list = []
        let obj = await ctx.model.topic.findAndCountAll(condition)
        if (0 < obj.count) {
            total = obj.count
            obj.rows.forEach(e => {
                list.push(e);
            });
        }

        return {total: total, data: list}
    }

    async info() {
        const {ctx, Sequelize} = this;
        let param = ctx.query;

        ctx.model.topic.belongsTo(ctx.model.user, {
            foreignKey: 'user_id',
            targetKey: 'userId'
        })

        let condition = {
            include: [{
                model: ctx.model.user,
                left: true
            }],
            attributes: ['id', 'title', 'userId', 'detail', 'replyCount', 'createAt', 'updateAt'],
            where: {
                id: Number(param.id)
            }
        }
        let info = await ctx.model.topic.findOne(condition)
        return info.dataValues
    }

    // 帖子发表
    async create() {
        const {ctx} = this
        let params = ctx.request.body
        let data = {
            userId: ctx.session.user.userId,
            title: params.title,
            detail: params.detail,
            scope: 0,
            reply_count: 0,
            flag: params.flag,
            sectionId: params.sectionId,
            updateAt: moment().locale('zh-cn').format('YYYY-MM-DD HH:mm:ss'),
            createAt: moment().locale('zh-cn').format('YYYY-MM-DD HH:mm:ss')
        }
        return await ctx.model.topic.create(data)
    }

    // 帖子更新
    async update() {
        const {ctx} = this
        let params = ctx.request.body
        let data = {
            title: params.title,
            detail: params.detail,
            scope: params.scope,
            sectionId: params.sectionId,
            updateAt: moment().locale('zh-cn').format('YYYY-MM-DD HH:mm:ss')
        }
        if(undefined != params.flag) {
            data.flag = params.flag
        }
        let condition = {
            where: {
                id: params.id,
                userId: ctx.session.user.userId
            }
        }
        return await ctx.model.topic.update(data, condition)
    }

    // 帖子删除
    async delete() {
        const {ctx, Sequelize} = this;
        let param = ctx.query;
        let userId = ctx.session.user.userId
        let data = {
            flag: -1
        }
        let condition = {
            where: {
                id: Number(param.id),
                user_id: userId
            },
            limit: 1
        }
        return await ctx.model.topic.update(data, condition)
    }

}

module.exports = TopicService