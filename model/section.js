
module.exports = app => {
    const { STRING, INTEGER, DATE } = app.Sequelize;
    const Section = app.model.define('section', {
        id: {
            type: INTEGER(10),
            primaryKey: true,
            autoIncrement: true
        },
        name: {
            type: STRING,
            allowNull: false
        },
        parentId: {
            type: INTEGER(10),
            field: 'parent_id'
        },
        sort: {
            type: INTEGER(3)
        },
        status: {
            type: INTEGER(1)
        },
        updateAt: {
            type: DATE,
            field: 'update_at'
        },
        createAt: {
            type: DATE,
            field: 'create_at'
        }
    }, {
        timestamps: false,
        freezeTableName: true
    });
    return Section;
}