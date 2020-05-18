class AdvertService {

    async list(param = {}) {
        const {ctx, Sequelize} = this;
        const Op = Sequelize.Op

        param = Object.assign(param, ctx.query);
        let offset = (param.page - 1) * param.pageSize
        
        let condition = {
            attributes: ['id', 'title', 'brief', 'link', 'assets', 'type', 'begAt', 'endAt', 'place', 'createAt'],
            where: {
                type: 1
            },
            offset: offset,
            limit: Number(param.pageSize)
        }
        
        if(undefined != param.type) {
            condition.where.type = Number(param.type)
        }

        if(undefined != param.place) {
            condition.where.place = param.place
        }

        let total = 0, list = []
        let obj = await ctx.model.advert.findAndCountAll(condition)
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

        let condition = {
            attributes: ['id', 'title', 'brief', 'link', 'assets', 'type', 'begAt', 'endAt', 'place', 'createAt'],
            where: {
                id: Number(param.id)
            }
        }
        let info = await ctx.model.topic.findOne(condition)
        return info.dataValues
    }

    // 新增
    async create() {
        
    }

    // 更新
    async update() {

    }
}

module.exports = AdvertService