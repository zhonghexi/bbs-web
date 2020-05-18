
module.exports = app => {
    const { STRING, INTEGER, DATE } = app.Sequelize;
    const Club = app.model.define('club', {
        id: {
            type: INTEGER(10),
            primaryKey: true,
            autoIncrement: true
        },
        name: {
            type: STRING(90),
            allowNull: false
        },
        cover: {
            type: STRING(1024),
            allowNull: false
        },
        brief: {
            type: STRING(420),
        },
        userId: {
            type: INTEGER(10),
            field: 'user_id'
        },
        starCount: {
            type: INTEGER(1),
            field: 'star_count'
        },
        topicCount: {
            type: INTEGER(5),
            field: 'topic_count'
        },
        userCount: {
            type: INTEGER(5),
            field: 'user_count'
        },
        status: {
            type: INTEGER(1)
        },
        createAt: {
            type: DATE,
            field: 'create_at'
        }
    }, {
        timestamps: false,
        freezeTableName: true
    });
    return Club;
}