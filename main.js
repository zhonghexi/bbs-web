import path from 'path'
import _ from "lodash"
import glob from "glob"

import koa from 'koa'
import onError from 'koa-onerror'
import logger from 'koa-logger'
import koaBody from 'koa-body'
import Sequelize from 'sequelize'
// import redis from 'redis'
import session from 'koa-session'

import config from './core/config'
import router from './router'

const app = new koa()
onError(app)

app.keys = ['C4CCFA50CA3422D31825753A6911AD20']
const SESSCFG = {
    key: 'koa:sess',  // 设置 session的名字 也是cookie中key
    maxAge: 86400000,
    autoCommit: true,
    overwrite: true, 
    httpOnly: true, // 是否允许客户端操作cookies true:不允许 false 允许
    signed: true, // 数字签名，保证数据不被修改
    rolling: false, // 过期时间访问顺延，指的是数据存储过期后；时候否继续加时间 false 不顺延  true 顺延
    renew: false
}
app.use(session(SESSCFG, app))

// 配置文件
app.use(config)

app.use(logger())

app.use(koaBody({
    multipart: true,
    formidable: {
        maxFileSize: 800*1024*1024    // 设置上传文件大小最大限制，默认8M
    }
}))

// 鉴权
app.use(async (ctx, next) => {
    const allow = [
        '/apitopic/setInfo'
    ]
    if(allow.indexOf(ctx.request.path) > -1) {
        if(undefined != ctx.session.user) {
            return await next()
        } else {
            ctx.body = {code: 2990, desc: 'no access'}
        }
    }
    return await next()
})

// 模型
app.use(async (ctx, next) => {
    let cfg = ctx.config.database;
    const sequelize = new Sequelize(cfg.name, cfg.user, cfg.password, {
        host: cfg.host,
        dialect: cfg.type, /* one of 'mysql' | 'mariadb' | 'postgres' | 'mssql' */
        dialectOptions: {
            useUTC: false //for reading from database
        },
        timezone: "+08:00"
    });
    ctx.sequelize = sequelize
    ctx.model = {}
    let models = glob.sync(`${__dirname}${path.sep}model${path.sep}*.js`)
    _.each(models, v => {
        let name = path.parse(v).name
        ctx.model[name] = require(v)({ Sequelize: Sequelize, model: sequelize })
    });
    await next()
});

// app.use(async (ctx, next) => {
//     ctx.redis = redis.createClient({
//         host: '192.168.199.10',
//         port: 6379,
//         db: 0,
//         password: 'redis,123'
//     });
//     ctx.redis.on("error", function (error) {
//         console.error(error)
//     });
//     await next()
// });

// 服务
app.use(async (ctx, next) => {
    ctx.service = {};
    let services = glob.sync(`${__dirname}${path.sep}service${path.sep}*.js`);
    _.each(services, v => {
        let name = path.parse(v).name
        let s = require(v);
        name = name.split('Service')[0]
        ctx.service[name] = new s();
        ctx.service[name].Sequelize = Sequelize
        ctx.service[name].ctx = ctx
        ctx.service[name].app = app
    });
    await next();
});

// 控制器
app.use(async (ctx, next) => {
    let controller = {};
    let ctrl = glob.sync(`${__dirname}${path.sep}controller${path.sep}*.js`);
    _.each(ctrl, v => {
        let name = path.parse(v).name
        let f = require(v);
        name = name.split('Controller')[0]
        controller[name] = new f()
    });
    app.use(router({ controller: controller }))
    await next()
});

// app.use(async (ctx, next) => {
//     await next();
//     const rt = ctx.response.get('X-Response-Time');
//     console.log(`${ctx.method} ${ctx.url} - ${rt}`);
// });

app.on('error', (error, ctx) => {
    console.log(JSON.stringify(ctx.onError), error)
});

app.listen(3000);
console.log('listening ...')