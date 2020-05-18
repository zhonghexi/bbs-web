
module.exports = app => {
    const { STRING, INTEGER, DATE } = app.Sequelize;
    const clubHasUser = app.model.define('club_has_user', {
        clubId: {
            type: INTEGER(10),
            field: 'club_id'
        },
        userId: {
            type: INTEGER(10),
            field: 'user_id'
        }
    }, {
        timestamps: false,
        freezeTableName: true
    });
    clubHasUser.removeAttribute('id')
    return clubHasUser
}