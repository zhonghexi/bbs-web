
module.exports = app => {
    const { STRING, INTEGER, DATE } = app.Sequelize;
    const Topic = app.model.define('topic', {
        id: {
            type: INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        userId: {
            type: INTEGER(10),
            // references: 'user',
            // referencesKey: 'user_id',
            field: 'user_id'
        },
        title: {
            type: STRING
        },
        detail: {
            type: STRING
        },
        flag: {
            type: INTEGER(1)
        },
        isTop: {
            type: INTEGER(1),
            field: 'is_top'
        },
        clubId: {
            type: INTEGER(10),
            field: 'club_id'
        },
        sectionId: {
            type: INTEGER(10),
            field: 'section_id'
        },
        scope: {
            type: INTEGER(1)
        },
        replyCount: {
            type: INTEGER(6),
            field: 'reply_count'
        },
        updateAt: {
            type: DATE,
            field: 'update_at'
        },
        createAt: {
            type: DATE,
            field: 'create_at'
        }
    },{
        timestamps: false,
        freezeTableName: true
    });
    return Topic;
}