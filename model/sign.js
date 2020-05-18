import moment from 'moment';

module.exports = app => {
    const { STRING, INTEGER, DATE } = app.Sequelize;
    const Sign = app.model.define('sign', {
        id: {
            type: INTEGER(10),
            primaryKey: true,
            autoIncrement: true
        },
        userId: {
            type: INTEGER(10),
            primaryKey: true,
            field: 'user_id'
        },
        mark: {
            type: STRING(64),
            allowNull: false
        },
        days: {
            type: INTEGER(2),
        },
        cycle : {
            type: DATE(6),
            get() {
                return moment(this.getDataValue('cycle')).format('YYYY-MM-DD')
            }
        }
    }, {
        timestamps: false,
        freezeTableName: true
    })
    return Sign
}