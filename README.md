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
生成的dist目录放线上服务器，Nginx配置如下：
```
server {
        listen       80;
        server_name  demo.libake.com; # 更换域名

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        set $root_path '/home/libake/web';

        location / {
            root   $root_path;
            index  index.html index.htm;
            try_files $uri $uri/ /index.html;
        }

        location /api {
            proxy_pass  http://127.0.0.1:4000;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
}
```
 *** 注：图像相关静态资源用了单独的域名部署

### 线上示例
```
http://demo.libake.com
```
