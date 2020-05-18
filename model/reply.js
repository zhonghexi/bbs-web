
module.exports = app => {
    const { STRING, INTEGER, DATE } = app.Sequelize;
    const Reply = app.model.define('reply', {
        id: {
            type: INTEGER(10),
            primaryKey: true,
            autoIncrement: true
        },
        userId: {
            type: INTEGER(10),
            field: 'user_id'
        },
        topicId: {
            type: INTEGER(10),
            field: 'topic_id'
        },
        detail: {
            type: STRING
        },
        createAt: {
            type: DATE,
            field: 'create_at'
        }
    }, {
        timestamps: false,
        freezeTableName: true
    })
    return Reply
}