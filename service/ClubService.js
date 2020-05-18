import moment from 'moment'

class SectionService {

    async list() {
        const {ctx, Sequelize} = this;
        const Op = Sequelize.Op
        let param = ctx.query;
        let offset = (param.page - 1) * param.pageSize

        ctx.model.club.belongsTo(ctx.model.user, {
            foreignKey: 'userId',
            targetKey: 'userId'
        })
        
        let condition = {
            include: [
                {
                    model: ctx.model.user
                }
            ],
            where: {
                status: 1
            },
            offset: offset,
            limit: Number(param.pageSize)
        }
        
        if(param.name) {
            condition.where.name = {
                [Op.like]: `${param.name}%`
            }
        }

        if(undefined != param.status) {
            condition.where.status = Number(param.status)
        }
        let total = 0, list = []
        let obj = await ctx.model.club.findAndCountAll(condition)
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
        const Op = Sequelize.Op
        let param = ctx.query;

        let page = 1, pageSize = 10
        if(!!param.page) {
            page = Number(param.page)
            pageSize = Number(param.pageSize)
        }
        let offset = (page - 1) * pageSize

        ctx.model.club.belongsTo(ctx.model.user, {
            foreignKey: 'userId',
            targetKey: 'userId'
        })
        let condition = {
            include: [
                {
                    model: ctx.model.user
                }
            ],
            where: {
                id: param.id
            }
        }
        let info = await ctx.model.club.findOne(condition)
        info = info.dataValues

        ctx.model.topic.belongsTo(ctx.model.user, {
            foreignKey: 'userId',
            targetKey: 'userId'
        })
        condition = {
            include: [
                {
                    model: ctx.model.user
                }
            ],
            where: {
                club_id: Number(param.id)
            },
            offset: offset,
            limit: pageSize
        }
        
        if(param.name) {
            condition.where.name = {
                [Op.like]: `${param.name}%`
            }
        }

        if(undefined != param.status) {
            condition.where.status = {
                [Op.gte]: 0
            }
        }
        let total = 0, list = []
        let obj = await ctx.model.topic.findAndCountAll(condition)
        if (0 < obj.count) {
            total = obj.count
            obj.rows.forEach(e => {
                list.push(e);
            });
        }
        info.topic = {total: total, list: list}

        return info
    }

    async rank() {
        const {ctx} = this;
        let param = ctx.query;
        let offset = (param.page - 1) * param.pageSize

        ctx.model.club.belongsTo(ctx.model.user, {
            foreignKey: 'userId',
            targetKey: 'userId'
        })
        
        let condition = {
            include: [
                {
                    model: ctx.model.user
                }
            ],
            where: {
                status: 1
            },
            order: [
                ['topic_count', 'DESC']
            ],
            offset: offset,
            limit: Number(param.pageSize)
        }

        let total = 0, list = []
        let obj = await ctx.model.club.findAndCountAll(condition)
        if (0 < obj.count) {
            total = obj.count
            obj.rows.forEach(e => {
                list.push(e);
            });
        }

        return {total: total, data: list}
    }

    /**
     * 
     * @param {*} cover 
     */
    async create(cover) {
        const {ctx} = this
        let param = ctx.request.body
        
        let condition = {
            where: {
                'name': param.name
            }
        }
        let ret = await ctx.model.club.findOne(condition)
        if(ret) {
            return false
        }
        let data = {
            userId: ctx.session.user.userId,
            name: param.name,
            cover: cover,
            brief: param.brief,
            remark: param.remark,
            createAt: moment().locale('zh-cn').format('YYYY-MM-DD HH:mm:ss')
        }
        return await ctx.model.club.create(data)
    }

    // 社区成员
    async member() {
        const {ctx, Sequelize} = this
        let param = ctx.query

        let where = "WHERE a.`id`=" + Number(param.id)
        // 统计条数
        let sql = "SELECT COUNT(*) cnt FROM `club` a RIGHT JOIN `club_has_user` b ON b.`club_id`=a.`id` LEFT JOIN `user` c ON b.`user_id`=c.`user_id`" + where
        let ret = await ctx.sequelize.query(sql, { replacements: ['active'], type: ctx.sequelize.QueryTypes.SELECT });
        let total = ret[0].cnt;
        // 获取数据
        sql = "SELECT c.* FROM `club` a RIGHT JOIN `club_has_user` b ON b.`club_id`=a.`id` LEFT JOIN `user` c ON b.`user_id`=c.`user_id`" + where + " ORDER BY c.`topic_count` DESC"
        ret = await ctx.sequelize.query(sql, { replacements: ['active'], type: ctx.sequelize.QueryTypes.SELECT });
        return {total: total, data: ret}
    }
}

module.exports = SectionService;