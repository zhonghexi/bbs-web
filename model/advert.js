
module.exports = app => {
    const { STRING, INTEGER, DATE } = app.Sequelize;
    const Advert = app.model.define('advert', {
        id: {
            type: INTEGER(10),
            primaryKey: true,
            autoIncrement: true
        },
        title: {
            type: STRING(90),
            allowNull: false
        },
        brief: {
            type: STRING(420)
        },
        link: {
            type: STRING(1024)
        },
        assets: {
            type: STRING(1024)
        },
        type: {
            type: INTEGER(3)
        },
        begAt: {
            type: DATE,
            field: 'beg_at'
        },
        endAt: {
            type: DATE,
            field: 'end_at'
        },
        brief: {
            type: STRING(30)
        },
        createAt: {
            type: DATE,
            field: 'create_at'
        }
    }, {
        timestamps: false,
        freezeTableName: true
    });
    return Advert;
}