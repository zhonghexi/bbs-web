# bbs-web

## 安装
这个项目是用koa2+vue开发。代码克隆下来后，像下面这样安装依赖
```
npm install
```

### 运行
- 进入根目录运行 npm run serve 将koa2跑起来
```shell
npm run serve
```
- 前端在根目录下的web
```
cd web
npm run serve
```

### 如果要部署线上环境，推荐用pm2跑koa2
后端部署
```
pm2 start -d npm -- run serve
```
前端部署
```
npm run build
```
生成的dist目录放线上服务器，配置好相关nginx


### 线上示例
```
http://demo.libake.com
```
