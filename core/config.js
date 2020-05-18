import path from 'path';
import fs from 'fs';
import yaml from 'js-yaml';

module.exports = async (ctx, next) => {
    let cfgCwd, cfgFile;
    cfgCwd = path.resolve(__dirname, '..') + path.sep + 'config';
    if('development' == ctx.app.env) {
        cfgFile = cfgCwd + path.sep + 'dev.yml';
    } else {
        cfgFile = cfgCwd + path.sep + 'product.yml';
    }
    // let pwd = path.resolve(__dirname, '..');
    let data = fs.readFileSync(cfgFile, 'utf8').toString();
    ctx.config = yaml.safeLoad(data);
    await next();
}