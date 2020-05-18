
module.exports = app => {
    const { STRING, INTEGER, DATE } = app.Sequelize;
    const userHasTopic = app.model.define('user_has_topic', {
        topicId: {
            type: INTEGER(10),
            field: 'topic_id'
        },
        userId: {
            type: INTEGER(10),
            field: 'user_id'
        }
    }, {
        timestamps: false,
        freezeTableName: true
    });
    userHasTopic.removeAttribute('id')
    return userHasTopic
}