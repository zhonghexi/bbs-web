import Router from 'koa-router'

module.exports = app => {
    const {controller} = app
    let router = new Router({prefix: '/api'})
    
    router.get('/club/getList', controller.Club.getList)
    router.get('/club/getRank', controller.Club.getRank)
    router.get('/club/getInfo', controller.Club.getInfo)
    router.post('/club/setInfo', controller.Club.setInfo)
    router.get('/club/member', controller.Club.member)

    router.get('/section/getList', controller.Section.getList)

    router.get('/topic/getList', controller.Topic.getList)
    router.get('/topic/getInfo', controller.Topic.getInfo)
    router.get('/topic/delete', controller.Topic.delInfo)
    router.post('/topic/setInfo', controller.Topic.setInfo)
    router.post('/topic/setSection', controller.Topic.setSection)

    router.get('/reply/getList', controller.Reply.getList)
    router.post('/reply/setInfo', controller.Reply.setInfo)

    router.get('/user/weekRank', controller.User.weekRank)
    router.get('/user/getSign', controller.User.getSign)
    router.post('/user/setSign', controller.User.setSign)
    router.get('/user/collect', controller.User.collect)
    router.post('/user/doCollect', controller.User.doCollect)
    router.post('/user/getInfo', controller.User.getInfo)

    router.get('/advert/getList', controller.Advert.getList)

    router.post('/auth/login', controller.Auth.login)
    router.post('/auth/register', controller.Auth.register)
    router.get('/auth/captcha', controller.Auth.captcha)
    router.post('/auth/upload', controller.Auth.upload)
    router.post('/auth/logout', controller.Auth.logout)
    router.post('/auth/preview', controller.Auth.preview)

    return router.routes()
}