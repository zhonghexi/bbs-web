import fs from 'fs'
import path from 'path'
import crypto from 'crypto'

module.exports = {

    ok: async (ctx) => {
        ctx.body = {
            code: 1000,
            desc: 'Success'
        }
    },

    okHasInfo: async (ctx, data) => {
        ctx.body = {
            code: 1100,
            info: data,
            desc: 'Success'
        }
    },

    okHasList: async (ctx, data, total) => {
        ctx.body = {
            code: 1200,
            list: data,
            total: total,
            desc: 'Success'
        }
    },

    fail: async (ctx) => {
        ctx.body = {
            code: 2000,
            desc: 'Fail'
        }
    },

    failHasDesc: async (ctx, code, desc) => {
        ctx.body = {
            code: code,
            desc: desc
        }
    },

    // 文件上传
    upload: async (file) => {
        const reader = fs.createReadStream(file.path)

        let upPath = path.join(__dirname, '../../') + `upload${path.sep}`
        let date = new Date()
        upPath += `${date.getFullYear()}${path.sep}`
        if(fs.existsSync(upPath)) {
            upPath += `${date.getMonth()}${path.sep}`
            if(!fs.existsSync(upPath)) {
                fs.mkdirSync(upPath)
            }else {
                upPath += `${date.getDay()}${path.sep}`
                if(!fs.existsSync(upPath)) {
                    fs.mkdirSync(upPath)
                }
            }
        } else {
            fs.mkdirSync(upPath)
        }
        let arrName = file.name.split('.')

        let fileName = crypto.createHash('md5').update(arrName[0]).digest('hex').substr(0, 16) + `.${arrName[1]}`
        let filePath = upPath + fileName
        const upStream = fs.createWriteStream(filePath)
        reader.pipe(upStream)
        return filePath.split('upload')[1]
    }
}