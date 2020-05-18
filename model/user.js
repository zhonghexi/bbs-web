
module.exports = app => {
    const { STRING, INTEGER } = app.Sequelize;
    const User = app.model.define('user', {
        userId: {
            type: INTEGER(10),
            primaryKey: true,
            autoIncrement: true,
            field: 'user_id'
        },
        username: {
            type: STRING(90),
            allowNull: false
        },
        nickname: {
            type: STRING(420),
        },
        password: {
            type: STRING(32),
        },
        avatar : {
            type: STRING(1024)
        },
        topicCount : {
            type: INTEGER(10),
            field: 'topic_count'
        },
        replyCount : {
            type: INTEGER(10),
            field: 'reply_count'
        }
    }, {
        timestamps: false,
        freezeTableName: true
    })
    return User
}