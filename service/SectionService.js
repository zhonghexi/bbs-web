class SectionService {

    constructor() {
        // console.log('This is service init');
    }

    async list() {
        const {ctx, Sequelize} = this;
        const Op = Sequelize.Op
        let param = ctx.query;
        let offset = (param.page - 1) * param.pageSize
        
        let condition = {
            attributes: ['id', 'name', 'sort'],
            where: {
                status: 1
            },
            offset: offset,
            limit: Number(param.pageSize)
        }
        
        if(param.parentId) {
            condition.where.parent_id = Number(param.parentId)
        }

        if(undefined != param.status) {
            condition.where.status = Number(param.status)
        }
        let total = 0, list = []
        let obj = await ctx.model.section.findAndCountAll(condition)
        if (0 < obj.count) {
            total = obj.count
            obj.rows.forEach(e => {
                list.push(e);
            });
        }

        return {total: total, data: list}
    }

    // 版块新增
    async create() {
        const {ctx} = this
        let params = ctx.request.body
        let sort = (undefined == params.sort) ? 127 : params.sort
        let status = (undefined == params.status) ? 1 : params.sort
        let data = {
            name: params.name,
            parentId: params.parentId,
            sort: sort,
            status: status,
            updateAt: moment().locale('zh-cn').format('YYYY-MM-DD HH:mm:ss'),
            createAt: moment().locale('zh-cn').format('YYYY-MM-DD HH:mm:ss')
        }
        return await ctx.model.section.create(data)
    }

    // 版块更新
    async update() {
        const {ctx} = this
        let params = ctx.request.body
        let sort = (undefined == params.sort) ? 127 : params.sort
        let status = (undefined == params.status) ? 1 : params.sort
        let data = {
            name: params.name,
            parentId: params.parentId,
            sort: sort,
            status: status,
            updateAt: moment().locale('zh-cn').format('YYYY-MM-DD HH:mm:ss')
        }
        let where = {
            id: params.id
        }
        return await ctx.model.section.update(data, where)
    }
}

module.exports = SectionService;