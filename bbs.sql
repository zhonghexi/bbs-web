-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- 主机： localhost
-- 生成日期： 2020-10-20 08:11:31
-- 服务器版本： 5.7.28
-- PHP 版本： 7.3.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 数据库： `bbs`
--

-- --------------------------------------------------------

--
-- 表的结构 `advert`
--

CREATE TABLE `advert` (
  `id` int(10) NOT NULL,
  `title` varchar(90) NOT NULL COMMENT '标题',
  `brief` varchar(420) NOT NULL COMMENT '简介',
  `link` varchar(1024) NOT NULL COMMENT '链接',
  `assets` varchar(1024) NOT NULL COMMENT '资源地址',
  `type` tinyint(3) NOT NULL COMMENT '0-文字，1-图片，2-视频',
  `beg_at` datetime NOT NULL COMMENT '开始时间',
  `end_at` datetime NOT NULL COMMENT '结束时间',
  `place` varchar(30) NOT NULL COMMENT '位置',
  `create_at` datetime NOT NULL COMMENT '创建时间'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='广告';

--
-- 转存表中的数据 `advert`
--

INSERT INTO `advert` (`id`, `title`, `brief`, `link`, `assets`, `type`, `beg_at`, `end_at`, `place`, `create_at`) VALUES
(1, '大自然', '一个安静、干净的天空', '', '2020/4/6/f5eb0dc0fde9f794.jpg', 1, '2020-05-05 00:00:00', '2020-05-29 00:00:00', 'home-top', '2020-05-05 00:00:00'),
(2, '社区', '心灵的归属', '', '2020/4/3/9661528bef9dda26.jpg', 1, '2020-05-05 00:00:00', '2020-05-29 00:00:00', 'home-top', '2020-05-05 00:00:00');

-- --------------------------------------------------------

--
-- 表的结构 `club`
--

CREATE TABLE `club` (
  `id` int(10) NOT NULL,
  `name` varchar(90) NOT NULL COMMENT '社区名称',
  `brief` varchar(420) NOT NULL COMMENT '简介',
  `cover` varchar(1024) NOT NULL DEFAULT '' COMMENT '封面',
  `user_id` int(10) NOT NULL DEFAULT '0' COMMENT '社长ID/申请人ID',
  `star_count` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0~5星',
  `topic_count` smallint(5) NOT NULL DEFAULT '0' COMMENT '帖子数量',
  `user_count` smallint(5) NOT NULL DEFAULT '0' COMMENT '用户数量',
  `status` tinyint(1) NOT NULL DEFAULT '2' COMMENT '0-禁用/驳回，1-审核通过，2-申请中',
  `remark` varchar(420) NOT NULL DEFAULT '' COMMENT '申请说明',
  `create_at` datetime NOT NULL COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='社区';

--
-- 转存表中的数据 `club`
--

INSERT INTO `club` (`id`, `name`, `brief`, `cover`, `user_id`, `star_count`, `topic_count`, `user_count`, `status`, `remark`, `create_at`) VALUES
(1, '篱笆客', '技术分享的地方', '/2020/4/3/b706bf1aea681de6.jpg', 1, 4, 0, 0, 1, '', '2020-05-20 14:35:36');

-- --------------------------------------------------------

--
-- 表的结构 `club_has_user`
--

CREATE TABLE `club_has_user` (
  `user_id` int(10) UNSIGNED NOT NULL COMMENT '用户ID',
  `club_id` int(10) UNSIGNED NOT NULL COMMENT '社区 ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='社区成员';

--
-- 转存表中的数据 `club_has_user`
--

INSERT INTO `club_has_user` (`user_id`, `club_id`) VALUES
(1, 1);

-- --------------------------------------------------------

--
-- 表的结构 `reply`
--

CREATE TABLE `reply` (
  `id` int(10) NOT NULL,
  `user_id` int(10) NOT NULL COMMENT '回复者',
  `topic_id` int(10) NOT NULL COMMENT '话题ID',
  `detail` text NOT NULL COMMENT '回复详情',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '-1-删除，0-隐藏，1-显示',
  `create_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='回复话题';

--
-- 转存表中的数据 `reply`
--

INSERT INTO `reply` (`id`, `user_id`, `topic_id`, `detail`, `status`, `create_at`) VALUES
(1, 1, 1, '<p>不错，不错</p>\r\n\r\n', 1, '2020-05-20 11:30:22');

--
-- 触发器 `reply`
--
DELIMITER $$
CREATE TRIGGER `ins_reply_update_topic` AFTER INSERT ON `reply` FOR EACH ROW begin 
UPDATE `topic` SET `reply_count`=`reply_count`+1 WHERE `id`=NEW.`topic_id`; 
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `ins_reply_update_user` AFTER INSERT ON `reply` FOR EACH ROW begin 
UPDATE `user` SET `reply_count`=`reply_count`+1 WHERE `user_id`=NEW.`user_id`; 
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- 表的结构 `section`
--

CREATE TABLE `section` (
  `id` int(10) NOT NULL,
  `name` varchar(30) NOT NULL COMMENT '版块名称',
  `parent_id` int(10) NOT NULL COMMENT '父级ID',
  `sort` tinyint(3) NOT NULL DEFAULT '127' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0-禁用，1-启用',
  `update_at` datetime NOT NULL,
  `create_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='版块';

--
-- 转存表中的数据 `section`
--

INSERT INTO `section` (`id`, `name`, `parent_id`, `sort`, `status`, `update_at`, `create_at`) VALUES
(1, '默认', 0, 127, 1, '2020-04-22 00:00:00', '2020-04-22 00:00:00'),
(2, '分享', 1, 2, 1, '2020-04-22 00:00:00', '2020-04-22 00:00:00'),
(3, '讨论', 1, 3, 1, '2020-04-22 00:00:00', '2020-04-22 00:00:00'),
(4, '建议', 1, 4, 1, '2020-04-22 00:00:00', '2020-04-22 00:00:00'),
(5, '公告', 1, 5, 1, '2020-04-22 00:00:00', '2020-04-22 00:00:00'),
(6, '动态', 1, 6, 1, '2020-04-22 00:00:00', '2020-04-22 00:00:00'),
(7, '提问', 1, 1, 1, '2020-04-22 00:00:00', '2020-04-22 00:00:00');

-- --------------------------------------------------------

--
-- 表的结构 `sign`
--

CREATE TABLE `sign` (
  `id` int(10) NOT NULL,
  `user_id` int(10) NOT NULL COMMENT '用户ID',
  `mark` varchar(64) NOT NULL DEFAULT '0' COMMENT '签到日',
  `days` tinyint(3) NOT NULL DEFAULT '1' COMMENT '连续签到天数',
  `cycle` date NOT NULL COMMENT '周期'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='签到';

--
-- 转存表中的数据 `sign`
--

INSERT INTO `sign` (`id`, `user_id`, `mark`, `days`, `cycle`) VALUES
(1, 1, '20,24', 2, '2020-05-31');

-- --------------------------------------------------------

--
-- 表的结构 `topic`
--

CREATE TABLE `topic` (
  `id` int(10) NOT NULL,
  `user_id` int(10) NOT NULL COMMENT '发起者',
  `title` varchar(90) NOT NULL COMMENT '标题',
  `detail` text NOT NULL COMMENT '详情',
  `flag` tinyint(1) NOT NULL DEFAULT '2' COMMENT '-1-删除，0-已结，1-未结，2-综合，3-精华',
  `is_top` tinyint(1) NOT NULL DEFAULT '0' COMMENT '置顶：0-否，1-是',
  `club_id` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '归属社区',
  `section_id` int(10) NOT NULL DEFAULT '0' COMMENT '版块ID',
  `scope` tinyint(3) NOT NULL DEFAULT '0' COMMENT '公布范围：0-不限制，1-仅限社区，2-仅限自己',
  `reply_count` int(6) NOT NULL DEFAULT '0' COMMENT '回复数',
  `update_at` datetime NOT NULL,
  `create_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='话题';

--
-- 转存表中的数据 `topic`
--

INSERT INTO `topic` (`id`, `user_id`, `title`, `detail`, `flag`, `is_top`, `club_id`, `section_id`, `scope`, `reply_count`, `update_at`, `create_at`) VALUES
(1, 1, 'PM2下使用 npm run 命令', '<p>npm run xxxx 是 node常用的启动方式之一，本文介绍下如何用PM2来实现该方式的启动。</p>\n<p>下面是项目的package.json文件部分代码：</p>\n<pre class=\"lang-json\"><code data-language=\"json\">&nbsp; \"scripts\": {\n&nbsp; &nbsp; \"dev\": \"node build/dev-server.js --env=local\",\n&nbsp; &nbsp; \"start\": \"node build/dev-server.js --env=local\",\n&nbsp; &nbsp; \"build\": \"node build/build.js --env=publish\",\n&nbsp; &nbsp; \"build-local\": \"node build/build.js\"\n}\n</code></pre>\n<blockquote>\n<p>注意，下面两种方式是等效的：</p>\n</blockquote>\n<p>1. npm run dev</p>\n<p>2. pm2 start&nbsp; npm -- run dev</p>\n<p>语法：pm2 start npm --watch --name &lt;taskname&gt; -- run &lt;scriptname&gt;;</p>\n<p>其中 -- watch监听代码变化，-- name重命名任务名称，-- run后面跟脚本名字</p>\n<p>至此，PM2实现npm run 来启动 node 的方法已经实现。</p>\n', 2, 0, 0, 3, 0, 1, '2020-05-20 11:26:06', '2020-05-20 11:26:06'),
(2, 1, 'ceph安装部署:源', '<pre><code>&lt;span class=\"colour\" style=\"color:rgb(153, 153, 153)\"&gt;**#**&lt;/span&gt;&lt;span class=\"bash\" style=\"box-sizing: border-box;\"&gt;&nbsp;cat /etc/yum.repos.d/ceph.repo&nbsp;&lt;/span&gt;\n[Ceph]\nname=Ceph packages for $basearch\nbaseurl=[http://mirrors.163.com/ceph/rpm-luminous/el7/$basearch](http://mirrors.163.com/ceph/rpm-luminous/el7/$basearch)\nenabled=1\npriority=1\ngpgcheck=1\ngpgkey=[https://download.ceph.com/keys/release.asc](https://download.ceph.com/keys/release.asc)\n\n[Ceph-noarch]\nname=Ceph noarch packages\nbaseurl=[http://mirrors.163.com/ceph/rpm-luminous/el7/noarch](http://mirrors.163.com/ceph/rpm-luminous/el7/noarch)\nenabled=1\npriority=1\ngpgcheck=1\ngpgkey=[https://download.ceph.com/keys/release.asc](https://download.ceph.com/keys/release.asc)\n\n[ceph-source]\nname=Ceph source packages\nbaseurl=[http://mirrors.163.com/ceph/rpm-luminous/el7/SRPMS](http://mirrors.163.com/ceph/rpm-luminous/el7/SRPMS)\nenabled=0\npriority=1\ngpgcheck=1\ngpgkey=[https://download.ceph.com/keys/release.asc](https://download.ceph.com/keys/release.asc)\n</code></pre>\n', 2, 1, 0, 2, 0, 0, '2020-05-20 14:54:09', '2020-05-20 11:33:52'),
(3, 1, 'visual studio 一些常用插件收藏', '<h3>取消根据不类型文件设置诸如tab的长度，使格式获得统一</h3>\n<pre class=\"lang-json\"><code data-language=\"json\">\"editor.detectIndentation\": false,\n</code></pre>\n<h3>插件收藏</h3>\n<ul>\n<li>\n<p>GitLens — Git supercharged</p>\n</li>\n<li>\n<p>CSS Peek</p>\n</li>\n<li>\n<p>Beautify css/sass/scss/less</p>\n</li>\n<li>\n<p>HTML Boilerplate</p>\n</li>\n<li>\n<p>Less IntelliSense</p>\n</li>\n<li>\n<p>PHP Intelephense</p>\n</li>\n<li>\n<p>Todo Tree</p>\n</li>\n<li>\n<p>spellright</p>\n</li>\n<li>\n<p>Auto Close Tag</p>\n</li>\n</ul>\n<h3>Visual Studio Code is unable to watch for file changes in this large workspace</h3>\n<p>When you see this notification, it indicates that the VS Code file watcher is running out of handles because the workspace is large and contains many files. The current limit can be viewed by running:</p>\n<pre><code>cat /proc/sys/fs/inotify/max_user_watches\n</code></pre>\n<p>The limit can be increased to its maximum by editing /etc/sysctl.conf and adding this line to the end of the file:</p>\n<pre><code>fs.inotify.max_user_watches=524288\n</code></pre>\n<p>The new value can then be loaded in by running sudo sysctl -p. Note that Arch Linux works a little differently, view this page for advice.</p>\n', 2, 0, 1, 2, 0, 0, '2020-05-20 18:41:00', '2020-05-20 18:41:00'),
(4, 1, 'angular 使用心得', '<h3>angular-cli.json常见配置</h3>\n<pre class=\"lang-json\"><code data-language=\"json\">{\n  \"project\": {\n    \"name\": \"ng-admin\", //项目名称\n    \"ejected\": false //标记该应用是否已经执行过eject命令把webpack配置释放出来\n  },\n  \"apps\": [\n    {\n      \"root\": \"src\", // 源码根目录\n      \"outDir\": \"dist\", // 编译后的输出目录，默认是dist/\n      \"assets\": [ // 记录资源文件夹，构建时复制到`outDir`指定的目录\n        \"assets\",\n        \"favicon.ico\"\n      ],\n      \"index\": \"index.html\", // 指定首页文件，默认值是\"index.html\"\n      \"main\": \"main.ts\", // 指定应用的入门文件\n      \"polyfills\": \"polyfills.ts\", // 指定polyfill文件\n      \"test\": \"test.ts\", // 指定测试入门文件\n      \"tsconfig\": \"tsconfig.app.json\", // 指定tsconfig文件\n      \"testTsconfig\": \"tsconfig.spec.json\", // 指定TypeScript单测脚本的tsconfig文件\n      \"tsconfig\":\"tsconfig.app.json\",\n      \"prefix\": \"app\", // 使用`ng generate`命令时，自动为selector元数据的值添加的前缀名\n      \"deployUrl\": \"//cdn.com.cn\", // 指定站点的部署地址，该值最终会赋给webpack的output.publicPath，常用于CDN部署\n      \"styles\": [ // 引入全局样式，构建时会打包进来，常用于第三方库引入的样式\n        \"styles.css\"\n      ],\n      \"scripts\": [ // 引入全局脚本，构建时会打包进来，常用语第三方库引入的脚本\n      ],\n      \"environmentSource\": \"environments/environment.ts\", // 基础环境配置\n      \"environments\": { // 子环境配置文件\n        \"dev\": \"environments/environment.ts\",\n        \"prod\": \"environments/environment.prod.ts\"\n      }\n    }\n  ],\n  \"e2e\": {\n    \"protractor\": {\n      \"config\": \"./protractor.conf.js\"\n    }\n  },\n  \"lint\": [\n    {\n      \"project\": \"src/tsconfig.app.json\"\n    },\n    {\n      \"project\": \"src/tsconfig.spec.json\"\n    },\n    {\n      \"project\": \"e2e/tsconfig.e2e.json\"\n    }\n  ],\n  \"test\": {\n    \"karma\": {\n      \"config\": \"./karma.conf.js\"\n    }\n  },\n  \"defaults\": { // 执行`ng generate`命令时的一些默认值\n    \"styleExt\": \"scss\", // 默认生成的样式文件后缀名\n    \"component\": {\n      \"flat\": false, // 生成组件时是否新建文件夹包装组件文件，默认为false（即新建文件夹）\n      \"spec\": true, // 是否生成spec文件，默认为true\n      \"inlineStyle\": false, // 新建时是否使用内联样式，默认为false\n      \"inlineTemplate\": false, // 新建时是否使用内联模板，默认为false\n      \"viewEncapsulation\": \"Emulated\", // 指定生成的组件的元数据viewEncapsulation的默认值\n      \"changeDetection\": \"OnPush\", // 指定生成的组件的元数据changeDetection的默认值\n    }\n  }\n}\n</code></pre>\n<h3>radio、select默认选择问题，必须使用value属性指令</h3>\n<pre class=\"lang-html\"><code data-language=\"html\">&lt;div class=\"form-group\"&gt;\n    &lt;label&gt;节点类型&lt;/label&gt;\n    &lt;input name=\"node_type\" type=\"radio\" [value]=\"1\" [(ngModel)]=\"model.node_type\"&gt;枝\n    &lt;input name=\"node_type\" type=\"radio\" [value]=\"2\" [(ngModel)]=\"model.node_type\"&gt;叶\n&lt;/div&gt;\n\n&lt;div class=\"form-group\"&gt;\n    &lt;label&gt;上级部门&lt;/label&gt;\n    &lt;select class=\"form-control\" name=\"parent_id\" [(ngModel)]=\"depModel.parent_id\"&gt;\n        &lt;option [ngValue]=\"0\"&gt;深圳市江花科技有限公司&lt;/option&gt;\n        &lt;option *ngFor=\"let item of depList\" [ngValue]=\"item.id\"&gt;{{item.name}}&lt;/option&gt;\n    &lt;/select&gt;\n&lt;/div&gt;\n</code></pre>\n<h3>checkbox选择问题</h3>\n<p>xx.component.html</p>\n<pre class=\"lang-html\"><code data-language=\"html\">&lt;table class=\"table table-bordered\"&gt;\n    &lt;thead&gt;\n        &lt;tr&gt;\n            &lt;th width=\"36\"&gt;\n                &lt;input type=\"checkbox\" (change)=\"aptAll($event)\"&gt;ID&lt;/th&gt;\n            &lt;th&gt;姓名&lt;/th&gt;\n            &lt;th&gt;职位&lt;/th&gt;\n            &lt;th&gt;手机号&lt;/th&gt;\n            &lt;th&gt;邮箱&lt;/th&gt;\n        &lt;/tr&gt;\n    &lt;/thead&gt;\n    &lt;tbody&gt;\n        &lt;tr *ngFor=\"let item of staffList;let i = index\"&gt;\n            &lt;td&gt;\n                &lt;input name=\"id[]\" type=\"checkbox\"&gt;{{i+1}}\n            &lt;/td&gt;\n            &lt;td&gt;{{item.real_name}}&lt;/td&gt;\n            &lt;td&gt;{{item.position}}&lt;/td&gt;\n            &lt;td&gt;{{item.mobile}}&lt;/td&gt;\n            &lt;td&gt;{{item.email}}&lt;/td&gt;\n        &lt;/tr&gt;\n    &lt;/tbody&gt;\n&lt;/table&gt;\n</code></pre>\n<p>xx.component.ts</p>\n<pre class=\"lang-typescript\"><code data-language=\"typescript\">aptAll(event) {\n    let oChkBox = document.getElementsByName(\'id[]\');\n    for(let x in oChkBox) {\n        if(\'object\' == typeof oChkBox[x]){\n            let obj = &lt;HTMLInputElement&gt;oChkBox[x];\n            obj.checked = event.target.checked;\n        }\n    }\n}\n</code></pre>\n<h3>终止冒泡，使用$event.stopPropagation()</h3>\n<pre class=\"lang-html\"><code data-language=\"html\">&lt;a herf=\"javascript:;\" (click)=\"modal(1, -1, 0); $event.stopPropagation()\"&gt;新增节点&lt;/a&gt;\n</code></pre>\n<h3>路由: 配置、参数设置及获取</h3>\n<ul>\n<li>\n<p>xx.component.html</p>\n</li>\n</ul>\n<pre class=\"lang-html\"><code data-language=\"html\">&lt;!-- 单参数 ---&gt;\n&lt;a *ngFor=\"let hero of heroes\" [routerLink]=\"[\'/detail\', hero.id]\"&gt;\n&lt;!-- 多参数 --&gt;\n&lt;a routerLink=\"/list\" [queryParams]=\"{id: 1, type: hero.type}\"&gt;\n</code></pre>\n<ul>\n<li>\n<p>xx.module.ts</p>\n</li>\n</ul>\n<pre class=\"lang-typescript\"><code data-language=\"typescript\">import { NgModule }             from \'@angular/core\';\nimport { RouterModule, Routes } from \'@angular/router\';\n \nimport { DashboardComponent }   from \'./dashboard.component\';\nimport { HeroDetailComponent }  from \'./hero-detail.component\';\n \nconst routes: Routes = [\n  { path: \'\', redirectTo: \'/dashboard\', pathMatch: \'full\' },\n  { path: \'detail/:id\', component: HeroDetailComponent },\n  { path: \'list\', component: HeroListComponent }\n];\n \n@NgModule({\n  imports: [ RouterModule.forRoot(routes) ],\n  exports: [ RouterModule ]\n})\nexport class xxModule {}\n</code></pre>\n<ul>\n<li>\n<p>xx.component.ts</p>\n</li>\n</ul>\n<pre class=\"lang-typescript\"><code data-language=\"typescript\">import { Component } from \'@angular/core\';\nimport { ActivatedRoute } from \'@angular/router\';\n\n@Component({\n    selector: \'app-detail\',\n    templateUrl: ``\n})\n\nexport class xxComponent {\n    constructor(private activatedRoute: ActivatedRoute) {\n    \n    }\n    \n    // 房间列表\n    getParam() {\n        this.activatedRoute.params.subscribe(params =&gt; {\n            this.id = params.id;\n        });\n    }\n}\n</code></pre>\n<h3>拦截器</h3>\n<ul>\n<li>\n<p>token.interceptor.ts</p>\n</li>\n</ul>\n<pre class=\"lang-typescript\"><code data-language=\"typescript\">import { Injectable } from \'@angular/core\';\nimport { HttpEvent, HttpInterceptor, HttpHandler, HttpRequest } from \'@angular/common/http\';\nimport { Observable } from \'rxjs/Observable\';\n\n@Injectable()\nexport class TokenInterceptor implements HttpInterceptor {\n\n    intercept(req: HttpRequest&lt;any&gt;, next: HttpHandler): Observable&lt;HttpEvent&lt;any&gt;&gt; {\n        const token = localStorage.getItem(\'token\');\n        if (token) {\n            req = req.clone({ setHeaders: { \'Access-Token\': token } });\n        }\n        return next.handle(req);\n    }\n}\n</code></pre>\n<ul>\n<li>\n<p>app.module.ts</p>\n</li>\n</ul>\n<pre class=\"lang-typescript\"><code data-language=\"typescript\">import { BrowserModule, Title } from \'@angular/platform-browser\';\nimport { NgModule } from \'@angular/core\';\nimport {BrowserAnimationsModule} from \'@angular/platform-browser/animations\';\nimport { Routes, RouterModule } from \'@angular/router\';\nimport { HttpClientModule, HTTP_INTERCEPTORS } from \'@angular/common/http\';\nimport { TokenInterceptor } from \'./shared/token.interceptor\';\nimport { AppComponent } from \'./app.component\';\n\nconst routes: Routes = [\n  { path: \'\', redirectTo: \'/admin/dash\', pathMatch: \'full\' },\n  { path: \'auth\', loadChildren: \'app/auth/auth.module#AuthModule\' },\n  { path: \'admin\', loadChildren: \'app/admin/admin.module#AdminModule\' }\n];\n\n@NgModule({\n  imports: [\n    BrowserModule,\n    BrowserAnimationsModule,\n    HttpClientModule,\n    RouterModule.forRoot(routes),\n  ],\n  declarations: [\n    AppComponent\n  ],\n  providers: [\n      Title,\n      {\n        provide: HTTP_INTERCEPTORS,\n        useClass: TokenInterceptor,\n        multi: true,\n      }\n    ],\n  bootstrap: [AppComponent]\n})\n\nexport class AppModule { }\n\n</code></pre>\n<h3>ng i18n</h3>\n<ul>\n<li>\n<p>main.ts</p>\n</li>\n</ul>\n<pre class=\"lang-ts\"><code data-language=\"ts\">import { enableProdMode, TRANSLATIONS, TRANSLATIONS_FORMAT } from \'@angular/core\';\nimport { platformBrowserDynamic } from \'@angular/platform-browser-dynamic\';\n\nimport { AppModule } from \'./app/app.module\';\nimport { environment } from \'./environments/environment\';\n\nif (environment.production) {\n    enableProdMode();\n}\n\n// use the require method provided by webpack\ndeclare const require;\n// we use the webpack raw-loader to return the content as a string\nconst translations = require(`raw-loader!./assets/locale/en_US.xlf`);\n\nplatformBrowserDynamic().bootstrapModule(AppModule, {\n    providers: [\n        {provide: TRANSLATIONS, useValue: translations},\n        {provide: TRANSLATIONS_FORMAT, useValue: \'xlf\'}\n    ]\n}).catch(err =&gt; console.error(err));\n\n</code></pre>\n<ul>\n<li>\n<p>app.module.ts</p>\n</li>\n</ul>\n<pre class=\"lang-ts\"><code data-language=\"ts\">import { BrowserModule, Title } from \'@angular/platform-browser\';\nimport { NgModule, LOCALE_ID } from \'@angular/core\';\nimport { BrowserAnimationsModule } from \'@angular/platform-browser/animations\';\nimport { HttpClientModule, HTTP_INTERCEPTORS } from \'@angular/common/http\';\n\nimport { AppRoutingModule } from \'./app-routing.module\';\n\nimport { TokenInterceptor } from \'./shared/token.interceptor\';\nimport { AppComponent } from \'./app.component\';\n\n@NgModule({\n    imports: [\n        BrowserModule,\n        BrowserAnimationsModule,\n        HttpClientModule,\n        AppRoutingModule,\n    ],\n    declarations: [\n        AppComponent,\n    ],\n    providers: [\n        Title,\n        {\n            provide: HTTP_INTERCEPTORS,\n            useClass: TokenInterceptor,\n            multi: true,\n        },\n        { provide: LOCALE_ID, useValue: \'en-US\' }\n    ],\n    bootstrap: [\n        AppComponent\n    ]\n})\nexport class AppModule {}\n\n</code></pre>\n<blockquote>\n<p>angular.json</p>\n</blockquote>\n<pre class=\"lang-json\"><code data-language=\"json\">{\n    \"$schema\": \"./node_modules/@angular/cli/lib/config/schema.json\",\n    \"version\": 1,\n    \"newProjectRoot\": \"projects\",\n    \"projects\": {\n        \"hw-personal-web\": {\n            \"root\": \"\",\n            \"sourceRoot\": \"src\",\n            \"projectType\": \"application\",\n            \"prefix\": \"app\",\n            \"schematics\": {\n                \"@schematics/angular:component\": {\n                    \"styleext\": \"less\"\n                }\n            },\n            \"architect\": {\n                \"build\": {\n                    \"builder\": \"@angular-devkit/build-angular:browser\",\n                    \"options\": {\n                        \"outputPath\": \"dist\",\n                        \"index\": \"src/index.html\",\n                        \"main\": \"src/main.ts\",\n                        \"polyfills\": \"src/polyfills.ts\",\n                        \"tsConfig\": \"src/tsconfig.app.json\",\n                        \"assets\": [\n                            \"src/favicon.ico\",\n                            \"src/assets\",\n                            {\n                                \"glob\": \"**/*\",\n                                \"input\": \"./node_modules/@ant-design/icons-angular/src/inline-svg/\",\n                                \"output\": \"/assets/\"\n                            }\n                        ],\n                        \"styles\": [\n                            \"./node_modules/ng-zorro-antd/ng-zorro-antd.min.css\",\n                            \"src/assets/jigsaw.less\",\n                            \"src/assets/styles.less\"\n                        ],\n                        \"scripts\": [\n                            \"node_modules/charting_library/charting_library.min.js\",\n                            \"src/assets/jigsaw.js\"\n                        ]\n                    },\n                    \"configurations\": {\n                        \"production\": {\n                            \"fileReplacements\": [\n                                {\n                                    \"replace\": \"src/environments/environment.ts\",\n                                    \"with\": \"src/environments/environment.prod.ts\"\n                                }\n                            ],\n                            \"optimization\": true,\n                            \"outputHashing\": \"all\",\n                            \"sourceMap\": false,\n                            \"extractCss\": true,\n                            \"namedChunks\": false,\n                            \"aot\": true,\n                            \"extractLicenses\": true,\n                            \"vendorChunk\": false,\n                            \"buildOptimizer\": true,\n                            \"budgets\": [\n                                {\n                                    \"type\": \"initial\",\n                                    \"maximumWarning\": \"2mb\",\n                                    \"maximumError\": \"5mb\"\n                                }\n                            ]\n                        },\n                        \"en\": {\n                            \"optimization\": true,\n                            \"outputHashing\": \"all\",\n                            \"outputPath\": \"dist/en/\",\n                            \"sourceMap\": false,\n                            \"extractCss\": true,\n                            \"namedChunks\": false,\n                            \"aot\": true,\n                            \"extractLicenses\": true,\n                            \"vendorChunk\": false,\n                            \"buildOptimizer\": true,\n                            \"fileReplacements\": [\n                              {\n                                \"replace\": \"src/environments/environment.ts\",\n                                \"with\": \"src/environments/environment.prod.ts\"\n                              }\n                            ],\n                            \"baseHref\": \"/en/\",\n                            \"i18nFile\": \"src/assets/locale/en_US.xlf\",\n                            \"i18nFormat\": \"xlf\",\n                            \"i18nLocale\": \"en\",\n                            \"i18nMissingTranslation\": \"error\"\n                        }\n                    }\n                },\n                \"serve\": {\n                    \"builder\": \"@angular-devkit/build-angular:dev-server\",\n                    \"options\": {\n                        \"browserTarget\": \"hw-personal-web:build\"\n                    },\n                    \"configurations\": {\n                        \"production\": {\n                            \"browserTarget\": \"hw-personal-web:build:production\"\n                        },\n                        \"en\": {\n                            \"browserTarget\": \"hw-personal-web:build:en\"\n                        }\n                    }\n                },\n                \"extract-i18n\": {\n                    \"builder\": \"@angular-devkit/build-angular:extract-i18n\",\n                    \"options\": {\n                        \"browserTarget\": \"hw-personal-web:build\"\n                    }\n                },\n                \"test\": {\n                    \"builder\": \"@angular-devkit/build-angular:karma\",\n                    \"options\": {\n                        \"main\": \"src/test.ts\",\n                        \"polyfills\": \"src/polyfills.ts\",\n                        \"tsConfig\": \"src/tsconfig.spec.json\",\n                        \"karmaConfig\": \"src/karma.conf.js\",\n                        \"styles\": [\n                            \"./node_modules/ng-zorro-antd/ng-zorro-antd.min.css\",\n                            \"src/styles.less\"\n                        ],\n                        \"scripts\": [],\n                        \"assets\": [\n                            \"src/favicon.ico\",\n                            \"src/assets\"\n                        ]\n                    }\n                },\n                \"lint\": {\n                    \"builder\": \"@angular-devkit/build-angular:tslint\",\n                    \"options\": {\n                        \"tsConfig\": [\n                            \"src/tsconfig.app.json\",\n                            \"src/tsconfig.spec.json\"\n                        ],\n                        \"exclude\": [\n                            \"**/node_modules/**\"\n                        ]\n                    }\n                }\n            }\n        },\n        \"hw-personal-web-e2e\": {\n            \"root\": \"e2e/\",\n            \"projectType\": \"application\",\n            \"prefix\": \"\",\n            \"architect\": {\n                \"e2e\": {\n                    \"builder\": \"@angular-devkit/build-angular:protractor\",\n                    \"options\": {\n                        \"protractorConfig\": \"e2e/protractor.conf.js\",\n                        \"devServerTarget\": \"hw-personal-web:serve\"\n                    },\n                    \"configurations\": {\n                        \"production\": {\n                            \"devServerTarget\": \"hw-personal-web:serve:production\"\n                        }\n                    }\n                },\n                \"lint\": {\n                    \"builder\": \"@angular-devkit/build-angular:tslint\",\n                    \"options\": {\n                        \"tsConfig\": \"e2e/tsconfig.e2e.json\",\n                        \"exclude\": [\n                            \"**/node_modules/**\"\n                        ]\n                    }\n                }\n            }\n        }\n    },\n    \"defaultProject\": \"hw-personal-web\"\n}\n</code></pre>\n<h3>Angular组件之间的交互</h3>\n<p>Angular组件之间的交互分为：</p>\n<p>1.通过输入型绑定把数据从父组件传到子组件。</p>\n<p>2.通过setter截听输入属性值的变化</p>\n<p>3.通过ngOnChanges()来截听输入属性值的变化</p>\n<p>4.父组件监听子组件的事件</p>\n<p>5.父组件与子组件通过本地变量互动</p>\n<p>6.父组件调用@ViewChild()</p>\n<p>7.父组件和子组件通过服务来通讯</p>\n<p>我们先介绍一下项目目录</p>\n<p>----------app.component.ts</p>\n<p>----------app.component.html</p>\n<p>----------app.component.css</p>\n<p>----------app.module.ts</p>\n<p>----------child(文件夹)</p>\n<p>--------------child.component.ts</p>\n<p>--------------child.component.html</p>\n<p>--------------child.component.css</p>\n<h4>通过输入型绑定把数据从父组件传到子组件</h4>\n<p>这个通讯方法的操作很简单，父组件发送自己的数据给子组件，子组件接收父组件传递过来的数据。</p>\n<p>1.app.component.html</p>\n<pre class=\"lang-html\"><code data-language=\"html\">&lt;child [childData]=\"appData\"&gt;&lt;/child&gt;&lt;!--childData是子组件的接收参数，appData是父组件传递的数据，整个数据传递过程的重点，桥梁--&gt;\n</code></pre>\n<p>2.app.component.ts</p>\n<pre class=\"lang-typescript\"><code data-language=\"typescript\">import { Component } from \'@angular/core\';\nimport { ChildComponent } from \'./child/child.component\';\n\n@Component({\n  selector: \'app-root\',\n  templateUrl: \'./app.component.html\',\n  styleUrls: [\'./app.component.css\']\n})\nexport class AppComponent {\n  title = \'app\';\n  appData=[\'Apple\',\'Banana\',\'watermelon\',\'pear\'];\n}\n</code></pre>\n<p>3.child.component.ts</p>\n<pre class=\"lang-typescript\"><code data-language=\"typescript\">import { Component,Input } from \'@angular/core\';//记得导入Input装饰器\n\n@Component({\n  selector: \'child\',\n  templateUrl: \'./child.component.html\',\n  styleUrls: [\'./child.component.css\']\n})\nexport class ChildComponent {\n  title = \'child\';\n  @Input() childData:any;//接收数据的接口\n}\n</code></pre>\n<p>4.child.component.html</p>\n<pre class=\"lang-html\"><code data-language=\"html\">&lt;ul&gt;\n    &lt;li *ngFor=\"let children of childData; let num1 = index\"&gt;{{num1}}--{{children}}&lt;/li&gt;\n&lt;/ul&gt;\n&lt;ul&gt;\n    &lt;li *ngFor=\"let children of childData; index as num2\"&gt;{{num2}}--{{children}}&lt;/li&gt;&lt;!--index的第二种写法--&gt;\n&lt;/ul&gt;\n</code></pre>\n<h4>通过setter截听输入属性值的变化</h4>\n<p>1.app.component.html</p>\n<pre class=\"lang-html\"><code data-language=\"html\">&lt;child *ngFor=\"let app of appData\" [child]=\"app\"&gt;&lt;/child&gt;\n</code></pre>\n<p>2.app.component.ts</p>\n<pre class=\"lang-typescript\"><code data-language=\"typescript\">import { Component } from \'@angular/core\';\n\n@Component({\n  selector: \'app-root\',\n  templateUrl: \'./app.component.html\',\n  styleUrls: [\'./app.component.css\']\n})\nexport class AppComponent {\n  title = \'app\';\n  appData=[\'Apple\',\'Banana\',\' \',\'pear\']; //父组件数据\n}\n</code></pre>\n<p>3.child.component.ts</p>\n<pre class=\"lang-typescript\"><code data-language=\"typescript\">import { Component,Input } from \'@angular/core\';\n\n@Component({\n  selector: \'child\',\n  templateUrl: \'./child.component.html\',\n  styleUrls: [\'./child.component.css\']\n})\nexport class ChildComponent {\n  title = \'child\';\n  private _name = \'\'; //定义一个私有向量，来暂时储存父组件传递过来的数据\n  @Input() set child(name: string) { //child是我们用来接收父组件传递过来的数据的一个变量，我们用setter来截取到这个变量，然后做一些修改，child这个变量名\n                                       //它是取决于父组件app.component.html里面的[child]=\"app\"，不能随便改动，child的形参名字可以随便修改\n    this._name = name.trim() || \'Oranges\'; //会trim掉名字里的空格，并把空值替换成Oranges。\n  }\n \n  get child(): string{ //用get重新获取重置过后的child变量，这个过程中_name这个是有变量就用到了\n      return this._name;\n  }\n}\n</code></pre>\n<p>4.child.component.html</p>\n<pre class=\"lang-html\"><code data-language=\"html\">&lt;p&gt;{{child}}&lt;/p&gt;\n</code></pre>\n<h4>通过ngOnChanges()来截听输入属性值的变化</h4>\n<p>OnChanges是一个生命周期钩子，一旦检测到该组件(或指令)的输入属性发生了变化，Angular就会调用它的ngOnChanges()方法。</p>\n<p>1.app.component.html</p>\n<pre class=\"lang-html\"><code data-language=\"html\">&lt;table&gt;\n    &lt;tr&gt;\n        &lt;td&gt;ID&lt;/td&gt;\n        &lt;td&gt;&lt;input type=\"text\" [(ngModel)]=\"id\"/&gt;&lt;/td&gt;\n    &lt;/tr&gt;\n    &lt;tr&gt;\n        &lt;td&gt;PassWord&lt;/td&gt;\n        &lt;td&gt;&lt;input type=\"text\" [(ngModel)]=\"password\"/&gt;&lt;/td&gt; &lt;!--使用ngModel要记住在app.module.ts里面添加FormsModule--&gt;\n    &lt;/tr&gt;\n    &lt;tr colspan=\"2\"&gt;\n        &lt;td&gt;&lt;button (click)=\"reset()\"&gt;Reset Log&lt;/button&gt;&lt;/td&gt;\n    &lt;/tr&gt;\n&lt;/table&gt;\n&lt;div&gt;\n    &lt;child [id]=\"id\" [password]=\"password\"&gt;&lt;/child&gt;\n&lt;/div&gt;\n</code></pre>\n<p>2.app.component.ts</p>\n<pre class=\"lang-typescript\"><code data-language=\"typescript\">import { Component,ViewChild } from \'@angular/core\';//这里使用了我们第六点将会用到的父组件调用@ViewChild()，第六点细讲\nimport { ChildComponent } from \'./child/child.component\';\n\n@Component({\n  selector: \'app-root\',\n  templateUrl: \'./app.component.html\',\n  styleUrls: [\'./app.component.css\']\n})\nexport class AppComponent {\n    title = \'app\';\n    id:number;\n    password:number;\n    @ViewChild(ChildComponent) childView: ChildComponent;//此处先忽略不看\n    constructor() {\n      this.reset();//构造函数，有初始化id和password的功能\n    }\n\n    reset() {\n        this.id = 100001;\n        this.password = 123456;\n        if (this.childView) { \n            this.childView.reset(); \n        }\n      }\n}\n</code></pre>\n<p>3.child.component.ts</p>\n<pre class=\"lang-typescript\"><code data-language=\"typescript\">import { Component, Input, OnChanges, SimpleChanges } from \'@angular/core\';\n\n@Component({\n  selector: \'child\',\n  templateUrl: \'./child.component.html\',\n  styleUrls: [\'./child.component.css\']\n})\nexport class ChildComponent implements OnChanges {\n  title = \'child\';\n  @Input() id: number;\n  @Input() password: number;\n  changeLog: string[] = []; //这个数组用来存放修改日志，修改一个input就会储存相应的记录\n  ngOnChanges(changes: SimpleChanges) {\n      for (let propName in changes) {\n          let chng = changes[propName];\n          let cur  = JSON.stringify(chng.currentValue);//修改前的数据\n          let prev = JSON.stringify(chng.previousValue);//修改后的数据\n          this.changeLog.push(`${propName}被修改了: 前一个数据 = ${cur}, 后一个数据 = ${prev}`);\n        }\n    }\n    reset() { \n      this.changeLog.length = 0; //清除日志\n    }\n}\n</code></pre>\n<p>4.child.component.html</p>\n<pre class=\"lang-html\"><code data-language=\"html\">&lt;div class=\"hero\"&gt;\n    &lt;h4&gt;-- Change Log --&lt;/h4&gt;\n    &lt;div *ngFor=\"let chg of changeLog\"&gt;{{chg}}&lt;/div&gt; &lt;!--将日志一条一条打印出来--&gt;\n&lt;/div&gt;\n</code></pre>\n<h4>父组件监听子组件的事件</h4>\n<p>通过@Output装饰器自定义一个方法，在需要emits(向上弹射)的函数里面弹射变量</p>\n<p>1.app.component.html</p>\n<pre class=\"lang-html\"><code data-language=\"html\">&lt;p&gt;{{title}}&lt;/p&gt;\n&lt;child (onClick)=\"onCli($event)\"&gt;&lt;/child&gt; &lt;!--onClick是子组件自定义的事件，触发onClick事件，执行父组件的onCli()方法--&gt;\n</code></pre>\n<p>2.app.component.ts</p>\n<pre class=\"lang-typescript\"><code data-language=\"typescript\">import { Component } from \'@angular/core\';\n\n@Component({\n  selector: \'app-root\',\n  templateUrl: \'./app.component.html\',\n  styleUrls: [\'./app.component.css\']\n})\nexport class AppComponent {\n    title=\"你还没点击按钮\";\n    onCli(isClick: boolean) { //父组件的方法，更换title的值\n        if(isClick){ //如果子组件弹射出来的变量为true\n            this.title=\"你点击了按钮\"; //那么就更改title\n        } \n      }\n}\n</code></pre>\n<p>3.child.component.ts</p>\n<pre class=\"lang-typescript\"><code data-language=\"typescript\">import { Component, EventEmitter, Output } from \'@angular/core\';//注意导入\n\n@Component({\n  selector: \'child\',\n  templateUrl: \'./child.component.html\',\n  styleUrls: [\'./child.component.css\']\n})\nexport class ChildComponent{\n  title = \'child\';\n  @Output() onClick = new EventEmitter&lt;boolean&gt;();//暴露自定义事件onClick\n  click(isClick: boolean) { //click()只是一个普通的方法\n    this.onClick.emit(isClick);//向父组件弹射isClick变量，这个变量在button被点击的时候触发\n  }\n}\n</code></pre>\n<p>4.child.component.html</p>\n<pre class=\"lang-html\"><code data-language=\"html\">&lt;button (click)=\"click(true)\"&gt;点击&lt;/button&gt; &lt;!--给click方法传入true--&gt;\n</code></pre>\n<h4>父组件与子组件通过本地变量互动</h4>\n<p>这种通讯比较简单，而且父组件可以同时调用子组件的变量或方法</p>\n<p>1.app.component.html</p>\n<pre class=\"lang-html\"><code data-language=\"html\">&lt;p&gt;{{title}}&lt;/p&gt;&lt;!--调用父组件自己的变量--&gt;\n&lt;p&gt;{{data.title}}&lt;/p&gt;&lt;!--调用子组件的变量--&gt;\n&lt;child #data&gt;&lt;/child&gt;&lt;!--在父组件模板里，新建一个本地变量来代表子组件，然后利用这个变量来读取子组件的属性和调用子组件的方法--&gt;\n&lt;button (click)=\"data.click()\"&gt;点击&lt;/button&gt;&lt;!--调用子组件的方法--&gt;\n</code></pre>\n<p>2.app.component.ts</p>\n<pre class=\"lang-typescript\"><code data-language=\"typescript\">import { Component } from \'@angular/core\';\n\n@Component({\n  selector: \'app-root\',\n  templateUrl: \'./app.component.html\',\n  styleUrls: [\'./app.component.css\']\n})\nexport class AppComponent {\n    title=\"app\";//父组件的变量\n}\n</code></pre>\n<p>3.child.component.ts</p>\n<pre class=\"lang-typescript\"><code data-language=\"typescript\">import { Component } from \'@angular/core\';\n\n@Component({\n  selector: \'child\',\n  templateUrl: \'./child.component.html\',\n  styleUrls: [\'./child.component.css\']\n})\nexport class ChildComponent{\n  title = \'child\';//子组件的变量\n  click(){//子组件的方法\n      this.title=\"changeChild\";\n  }\n}\n</code></pre>\n<p>child.component.html不用编写代码</p>\n<h4>父组件调用@ViewChild()</h4>\n<p>这种父子组件之间的通讯方式也很容易理解,项目代码和第五个通讯方式差不多<br>\n1.app.component.html</p>\n<pre class=\"lang-html\"><code data-language=\"html\">&lt;p&gt;{{title}}&lt;/p&gt;\n&lt;p&gt;{{data.title}}&lt;/p&gt;\n&lt;child #data&gt;&lt;/child&gt;\n&lt;button (click)=\"onclick()\"&gt;点击&lt;/button&gt;&lt;!--注意这里，跟第五个方法有些区别--&gt;\n</code></pre>\n<p>2.app.component.ts</p>\n<pre class=\"lang-typescript\"><code data-language=\"typescript\">import { Component } from \'@angular/core\';\nimport { ViewChild } from \'@angular/core\';\nimport { ChildComponent } from \'./child/child.component\';\n\n@Component({\n  selector: \'app-root\',\n  templateUrl: \'./app.component.html\',\n  styleUrls: [\'./app.component.css\']\n})\nexport class AppComponent {\n    title=\"app\";\n    @ViewChild(ChildComponent)//通过@ViewChild属性装饰器，将子组件CountdownTimerComponent注入到私有属性timerComponent里面，此处不能加分号。\n    private child: ChildComponent;\n    onclick(){\n        this.child.click();\n    }\n}\n</code></pre>\n<p>3.child.component.ts</p>\n<pre class=\"lang-typescript\"><code data-language=\"typescript\">import { Component } from \'@angular/core\';\n\n@Component({\n  selector: \'child\',\n  templateUrl: \'./child.component.html\',\n  styleUrls: [\'./child.component.css\']\n})\nexport class ChildComponent{\n  title = \'child\';\n  click(){\n      this.title=\"changeChild\";\n  }\n}\n</code></pre>\n<p>child.component.html也是不用编写代码</p>\n<h4>父组件和子组件通过服务来通讯</h4>\n<p>这个实验要在app.component.html加入新的文件Service.ts<br>\n1.app.component.html</p>\n<pre class=\"lang-html\"><code data-language=\"html\">&lt;p&gt;{{title}}&lt;/p&gt;\n&lt;button (click)=\"onclick()\"&gt;点击&lt;/button&gt;\n&lt;child&gt;&lt;/child&gt;\n</code></pre>\n<p>2.app.component.ts</p>\n<pre class=\"lang-typescript\"><code data-language=\"typescript\">import { Component } from \'@angular/core\';\nimport { ChildComponent } from \'./child/child.component\';\nimport { Service } from \'./Service\';//导入服务\n\n@Component({\n  selector: \'app-root\',\n  templateUrl: \'./app.component.html\',\n  styleUrls: [\'./app.component.css\']\n})\nexport class AppComponent {\n    title=\'app\';\n    constructor(public pService: Service) { //原来的写法是这样的pService = new Service();\n     }\n    onclick(){\n        this.title = this.pService.getData();\n        console.log(this.title);\n    }\n}\n</code></pre>\n<p>3.child.component.ts</p>\n<pre class=\"lang-typescript\"><code data-language=\"typescript\">import { Component } from \'@angular/core\';\nimport { Service } from \'../Service\';\n\n@Component({\n  selector: \'child\',\n  templateUrl: \'./child.component.html\',\n  styleUrls: [\'./child.component.css\']\n})\nexport class ChildComponent{\n  title = \'child\';\n  constructor(public pService: Service) {\n    }\n  onclick(){\n    this.title = this.pService.getData();\n  }\n}\n</code></pre>\n<p>4.child.component.html</p>\n<pre class=\"lang-html\"><code data-language=\"html\">&lt;p&gt;{{title}}&lt;/p&gt;\n&lt;button (click)=\"onclick()\"&gt;点击&lt;/button&gt;\n</code></pre>\n<p>app.component.html和child.component.html，app.component.ts和child.component.ts的代码几乎一样，目的是要展示出服务在父子组件甚至任何组件里面的使用</p>\n<p>5.Service.ts</p>\n<pre class=\"lang-typescript\"><code data-language=\"typescript\">import {Injectable} from \"@angular/core\"\n\n@Injectable()\nexport class Service {\n  title=\'service\';//公共变量\n  getData() {//公共方法\n    return this.title;\n  }\n}\n</code></pre>\n<p>6.app.module.ts</p>\n<pre class=\"lang-typescript\"><code data-language=\"typescript\">import { BrowserModule } from \'@angular/platform-browser\';\nimport { NgModule } from \'@angular/core\';\n\nimport { AppComponent } from \'./app.component\';\nimport { ChildComponent } from \'./child/child.component\';\nimport { Service } from \'./Service\';//导入服务\n\n@NgModule({\n  declarations: [\n    AppComponent,\n    ChildComponent\n  ],\n  imports: [\n    BrowserModule\n  ],\n  providers: [Service],//注册服务\n  bootstrap: [AppComponent]\n})\nexport class AppModule { }\n</code></pre>\n<h3>文件上传</h3>\n<ul>\n<li>\n<p>attest.component.html</p>\n</li>\n</ul>\n<pre class=\"lang-html\"><code data-language=\"html\">&lt;form class=\"box-body\" (ngSubmit)=\"onSubmit()\" enctype=\"multipart/form-data\"&gt;\n    &lt;div class=\"cert\"&gt;\n        &lt;div class=\"btn-cert\"&gt;\n            &lt;img [src]=\"sanitizer.bypassSecurityTrustUrl(imgsrc[0])\" alt=\"\"&gt;\n            &lt;input type=\"file\" (change)=\"preview($event, 0)\" accept=\"image/png, image/jpeg\"&gt;\n            &lt;span&gt;上传身份证正面&lt;/span&gt;\n        &lt;/div&gt;\n        &lt;div class=\"btn-cert\"&gt;\n            &lt;img [src]=\"sanitizer.bypassSecurityTrustUrl(imgsrc[1])\" alt=\"\"&gt;\n            &lt;input type=\"file\" (change)=\"preview($event, 1)\" accept=\"image/png, image/jpeg\"&gt;\n            &lt;span&gt;上传身份证反面&lt;/span&gt;\n        &lt;/div&gt;\n        &lt;div class=\"btn-cert\"&gt;\n            &lt;img [src]=\"sanitizer.bypassSecurityTrustUrl(imgsrc[2])\" alt=\"\"&gt;\n            &lt;input type=\"file\" (change)=\"preview($event, 2)\" accept=\"image/png, image/jpeg\"&gt;\n            &lt;span&gt;上传手持身份证照片&lt;/span&gt;\n        &lt;/div&gt;\n    &lt;/div&gt;\n    &lt;div class=\"from-group\"&gt;\n        &lt;button class=\"btn\" type=\"submit\"&gt;点击提交&lt;/button&gt;\n    &lt;/div&gt;\n&lt;/form&gt;\n</code></pre>\n<ul>\n<li>\n<p>attest.component.ts</p>\n</li>\n</ul>\n<pre class=\"lang-typescript\"><code data-language=\"typescript\">preview(event, index?: number) {\n    let fileList: FileList = event.target.files; // 获取图片这里只操作一张图片\n    if(0 &gt;= fileList.length) {\n        return false;\n    }\n    if (undefined == index) {\n        index = 0;\n    }\n\n    this.imgsrc[index] = window.URL.createObjectURL(fileList[0]);\n    if(this.fileList[index]) {\n        this.fileList[index] = fileList[0];\n    } else {\n        this.fileList.push(fileList[0]);\n    }\n}\n\nonSubmit() {\n    this.userService.upload(this.fileList).subscribe(res =&gt; {\n        console.log(res);\n    });\n}\n</code></pre>\n<ul>\n<li>\n<p>attest.service.ts</p>\n</li>\n</ul>\n<pre class=\"lang-typescript\"><code data-language=\"typescript\">upload(file): Observable&lt;any&gt; {\n    const url = \'/personal/user/upload\';\n    let formData:FormData = new FormData();\n    if(0 &lt; file.length) {\n        for(let i = 0; i &lt; file.length; i++) {\n            formData.append(\'uploadFile[]\', file[i], file[i].name);\n        }\n    }\n    \n    return this.http.post(url, formData);\n}\n</code></pre>\n<h3>常用管道</h3>\n<ul>\n<li>\n<p>大小写转换管道</p>\n</li>\n</ul>\n<p>uppercase将字符串转换为大写<br>\nlowercase将字符串转换为小写</p>\n<pre class=\"lang-html\"><code data-language=\"html\">str:string = \'hello\'\n\n&lt;p&gt;将字符串转换为大写{{str | uppercase}}&lt;/p&gt;\n</code></pre>\n<ul>\n<li>\n<p>日期管道</p>\n</li>\n</ul>\n<p>date日期管道符可以接受参数，用来规定输出日期的格式。</p>\n<pre class=\"lang-html\"><code data-language=\"html\">today:Date = new Date();\n\n&lt;p&gt;现在的时间是{{today | date:\'yyyy-MM-dd HH:mm:ss\'}}&lt;/p&gt;\n</code></pre>\n<ul>\n<li>\n<p>小数管道</p>\n</li>\n</ul>\n<p>number管道用来将数字处理为我们需要的小数格式<br>\n接收的参数格式为{最少整数位数}.{最少小数位数}-{最多小数位数}<br>\n其中最少整数位数默认为1<br>\n最少小数位数默认为0<br>\n最多小数位数默认为3<br>\n当小数位数少于规定的{最少小数位数}时，会自动补0<br>\n当小数位数多于规定的{最多小数位数}时，会四舍五入</p>\n<pre class=\"lang-html\"><code data-language=\"html\">pi:number = 3.14159;\n\n&lt;p&gt;圆周率是{{pi | number:\'2.2-4\'}}&lt;/p&gt;\n</code></pre>\n<p>页面上会显示 圆周率是03.1416</p>\n<ul>\n<li>\n<p>货币管道</p>\n</li>\n</ul>\n<p>currency管道用来将数字转换为货币格式</p>\n<pre class=\"lang-html\"><code data-language=\"html\">a:number = 8.2515\nb:number = 156.548\n\n&lt;p&gt;{{a | currency:\'USD\':false}}&lt;/p&gt;\n&lt;p&gt;{{b | currency:\'USD\':true:\'4.2-2\'}}&lt;/p&gt;\n</code></pre>\n<p>页面上将显示 USD8.250156.55这里的′USD′是美元UnitedStatesdollar的缩写，当为false时不显示0156.55这里的′USD′是美元UnitedStatesdollar的缩写，当为false时不显示符，当为true时，则显示$符。后面的规定小数位数的参数和上面介绍的一样。</p>\n<h3>导出文件</h3>\n<p>安装插件</p>\n<pre><code>npm install xlsx --save\n\nnpm install file-saver --save\n</code></pre>\n<ul>\n<li>\n<p>excel.service.ts</p>\n</li>\n</ul>\n<pre class=\"lang-js\"><code data-language=\"js\">import { Injectable } from \'@angular/core\';\nimport * as FileSaver from \'file-saver\';\nimport * as XLSX from \'xlsx\';\n\nconst EXCEL_TYPE = \'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=UTF-8\';\nconst EXCEL_EXTENSION = \'.xlsx\';\n\n@Injectable()\nexport class ExcelService {\n\n  constructor() { }\n\n  public exportAsExcelFile(json: any[], excelFileName: string): void {\n    \n    const worksheet: XLSX.WorkSheet = XLSX.utils.json_to_sheet(json);\n    console.log(\'worksheet\',worksheet);\n    const workbook: XLSX.WorkBook = { Sheets: { \'data\': worksheet }, SheetNames: [\'data\'] };\n    const excelBuffer: any = XLSX.write(workbook, { bookType: \'xlsx\', type: \'array\' });\n    //const excelBuffer: any = XLSX.write(workbook, { bookType: \'xlsx\', type: \'buffer\' });\n    this.saveAsExcelFile(excelBuffer, excelFileName);\n  }\n\n  private saveAsExcelFile(buffer: any, fileName: string): void {\n    const data: Blob = new Blob([buffer], {\n      type: EXCEL_TYPE\n    });\n    FileSaver.saveAs(data, fileName + \'_export_\' + new Date().getTime() + EXCEL_EXTENSION);\n  }\n\n}\n</code></pre>\n<ul>\n<li>\n<p>app.component.html</p>\n</li>\n</ul>\n<pre class=\"lang-html\"><code data-language=\"html\">&lt;p&gt;\n  Exporting an excel file of type .xslx !!!\n&lt;/p&gt;\n&lt;p&gt;Export as XLSX by clicking the below button&lt;/p&gt;\n\n&lt;button (click)=\"exportAsXLSX()\"&gt;&lt;i class=\"fa fa-file-excel-o\" style=\"font-size:48px;color:blue\"&gt;&lt;/i&gt;&lt;/button&gt;\n&lt;table&gt;\n	&lt;tr&gt;\n		&lt;td&gt;Eid&lt;/td&gt;\n		&lt;td&gt;Ename&lt;/td&gt;\n		&lt;td&gt;Esal&lt;/td&gt;\n	&lt;/tr&gt;\n	&lt;tr *ngFor=\"let item of data\"&gt;\n		&lt;td&gt;{{item.eid}}&lt;/td&gt;\n		&lt;td&gt;{{item.ename}}&lt;/td&gt;\n		&lt;td&gt;{{item.esal}}&lt;/td&gt;\n	&lt;/tr&gt;\n&lt;/table&gt;\n</code></pre>\n<ul>\n<li>\n<p>app.component.ts</p>\n</li>\n</ul>\n<pre class=\"lang-js\"><code data-language=\"js\">import { Component } from \'@angular/core\';\nimport { ExcelService } from \'./services/excel.service\';\n\n@Component({\n  selector: \'my-app\',\n  templateUrl: \'./app.component.html\',\n  styleUrls: [\'./app.component.css\']\n})\nexport class AppComponent {\n  name = \'Angular 6\';\n  data: any = [{\n    eid: \'e101\',\n    ename: \'ravi\',\n    esal: 1000\n  },\n  {\n    eid: \'e102\',\n    ename: \'ram\',\n    esal: 2000\n  },\n  {\n    eid: \'e103\',\n    ename: \'rajesh\',\n    esal: 3000\n  }];\n  constructor(private excelService: ExcelService) {\n\n  }\n  exportAsXLSX(): void {\n    this.excelService.exportAsExcelFile(this.data, \'sample\');\n  }\n}\n\n</code></pre>\n', 2, 0, 0, 6, 0, 0, '2020-05-20 18:43:56', '2020-05-20 18:43:56'),
(5, 1, '今天正式上线，是一个值得高兴的日子', '<p>经过近一个的开发，今天正式上线，源码可以从github上下载，下载地址如下<br>\n<a href=\"https://github.com/zhonghexi/bbs\">https://github.com/zhonghexi/bbs</a><br>\n文档还没有完善，近期会陆续完善，本项目仅作技术交流，qq:223779899</p>\n', 2, 1, 1, 5, 0, 0, '2020-05-20 18:50:44', '2020-05-20 18:50:44'),
(6, 1, 'linux下一些常用软件', '<p>1、GIMP类似potoshop的一款功能强大的图像处理软件，potoshop能做的事它基本上也能做，不过对于用惯了potoshop的可能需要一定时间的适应。</p>\n<p>2、FileZilla 对于经常使用FTP工具的朋友来说，它真的是一个福音。不用去找什么破解说明啊，因为它是免费开源的，而且还是跨平台，功能上也绝不亚于其他同类的FTP工具。</p>\n<p>3、Xmind思维导图软件，部分功能收费，不过对于一般的用途都能支持。</p>\n<p>4、Agave配色工具，不过我最喜欢用它的取色功能，做程序的吧，难免要写些前台页面，这就会遇上要获取其他页面的某一处的颜色，而用肉眼根本没法准确分辩出来，这时它可以帮轻易搞定。</p>\n<p>5、Shutter截图工具，习惯于QQ的截图的功能，但QQ是没有linux的版本，也没有对应的相关工具，它是一个不错的选择，功能比较强大，可以满足于所以截图需求，唯一的不足就是截图后先要保存才能发送给好友，不能直接复制发送。</p>\n<p>6、SMPlayer试用过多个播放器，最终还是选择了它，不过就是界面还有待改进。</p>\n<p>7、Dia（dia-gnome）是图表，曲线图，海图等图形表格的编辑器。它支持UML静态结构图表（类图），实体关系图，网络图表以及其它更多图表。图表可以导出为postscript和其他格式。启动直接在终端输入dia, dia-gnome, dia-gnome-integrated其中的一个命令回车即可打开软件。此软件于UML、数据库E-R设计是一个非常优秀的软件。安装方式可在新立得输入dia-gnome搜索安装。</p>\n<p>8、Mysql Workbench是一个专业的mysql数据模型设计软件，有了它在linux环境下不用再去纠结找不到windows环境下的PowerDesigner。</p>\n<p>10、Pencil一个linux环境下的产品原型设计软件，虽不能跟Axure匹敌，但绝大多数原型设计需求还是可以满足，想在linux下做产品原型设计的朋友我认为是一个不二的选择。安装方式在ubuntu下非常简单，从<a href=\"http://pencil.evolus.vn/\">官网</a>下载deb包在新立德运行安装即可。</p>\n<p>11、wireshark（前称Ethereal）是一个<a href=\"http://baike.baidu.com/view/6102086.htm\">网络封包</a>分析<a href=\"http://baike.baidu.com/view/37.htm\">软件</a>。</p>\n<p>12、Fcitx[ˈfaɪtɪks]是 Free Chinese Input Toy for X 的英文缩写，中文名为小企鹅中文输入法，是一个以 GPL 方式发布的输入法框架， 编写它的目是为桌面环境提供一个灵活的输入方案，彻底解决在GNU/Linux下没有一个好的中文输入法的问题。</p>\n<p>13、Siege是一个压力测试和评测工具，设计用于WEB开发这评估应用在压力下的承受能力：可以根据配置对一个WEB站点进行多用户的并发访问，记录每个用户所有请求过程的相应时间，并在一定数量的并发访问下重复进行。</p>\n<p>14、<a href=\"http://live.gnome.org/Planner\"><span class=\"colour\" style=\"color:rgb(0, 56, 132)\" data-tomark-pass=\"\"><u data-tomark-pass=\"\">Planner</u></span></a>是一款开源、易用、跨平台的项目管理软件，可以制作出完美的甘特图，在线比较好类似的工具有<a href=\"http://www.geeseteam.com/\">雁阵</a>以及<a href=\"https://www.smartsheet.com\">smartsheet</a></p>\n<p>15、Postman是chrome扩展下的一个接口调工具，对于经常写接口的同学来说绝对必备工具</p>\n<p>16、builtwith可以查询出某网站背后是由哪些技术来支持的，比如操作系统的类型、所采用的访问量统计服务、采用的发布平台、广告平台、语言框架、聚合功能、页面文档信息、网站编码及操作系统信息等等。</p>\n<p>17、Tmux是一个优秀的终端复用软件，类似GNU Screen，通过一个终端登录远程主机并运行tmux后，在其中可以开启多个控制台而无需再“浪费”多余的终端来连接这台远程主机。</p>\n<p>18、<a href=\"http://www.scootersoftware.com/download.php\"><span class=\"colour\" style=\"color:rgb(0, 56, 132)\" data-tomark-pass=\"\"><u data-tomark-pass=\"\">Beyond Compare</u></span></a><span class=\"colour\" style=\"color:rgb(57, 57, 57)\" data-tomark-pass=\"\">&nbsp;超级好用的文件比较工具，而且更让人惊喜的是跨平台，支持windows、linux、mac，对于喜欢在各平台切换的朋友绝对是一个利器。</span><br>\n<span class=\"colour\" style=\"color:rgb(57, 57, 57)\" data-tomark-pass=\"\"></span><br>\n<span class=\"colour\" style=\"color:rgb(57, 57, 57)\" data-tomark-pass=\"\">19、</span>snipaste<span class=\"colour\" style=\"color:rgb(57, 57, 57)\" data-tomark-pass=\"\">&nbsp;屏幕截图+取色工具，非常好用，美中不足，它是一款收费软件。</span><br>\n<span class=\"colour\" style=\"color:rgb(57, 57, 57)\" data-tomark-pass=\"\">20、</span></p>\n', 2, 0, 0, 2, 0, 0, '2020-05-24 11:36:59', '2020-05-24 11:35:42');

--
-- 触发器 `topic`
--
DELIMITER $$
CREATE TRIGGER `ins_topic_update_user` AFTER INSERT ON `topic` FOR EACH ROW begin 
UPDATE `user` SET `topic_count`=`topic_count`+1 WHERE `user_id`=NEW.`user_id`; 
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- 表的结构 `user`
--

CREATE TABLE `user` (
  `user_id` int(10) NOT NULL COMMENT '用户ID',
  `username` varchar(16) NOT NULL COMMENT '账号',
  `nickname` varchar(30) NOT NULL COMMENT '昵称',
  `password` varchar(32) NOT NULL DEFAULT '' COMMENT '登录密码',
  `avatar` varchar(1024) NOT NULL COMMENT '头像',
  `reply_count` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '回复次数',
  `topic_count` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '发贴数量',
  `brief` varchar(420) NOT NULL DEFAULT '' COMMENT '简介',
  `liba` int(8) NOT NULL DEFAULT '0' COMMENT '篱笆'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `user`
--

INSERT INTO `user` (`user_id`, `username`, `nickname`, `password`, `avatar`, `reply_count`, `topic_count`, `brief`, `liba`) VALUES
(1, 'kim', 'kim', '31f4639449762cfc280b531e1c63a711', 'avatar/03.jpg', 1, 6, '', 0);

-- --------------------------------------------------------

--
-- 表的结构 `user_has_topic`
--

CREATE TABLE `user_has_topic` (
  `user_id` int(10) NOT NULL COMMENT '用户ID',
  `topic_id` int(10) NOT NULL COMMENT '帖子ID'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='我的收藏';

--
-- 转储表的索引
--

--
-- 表的索引 `advert`
--
ALTER TABLE `advert`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `club`
--
ALTER TABLE `club`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `reply`
--
ALTER TABLE `reply`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `section`
--
ALTER TABLE `section`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `sign`
--
ALTER TABLE `sign`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `topic`
--
ALTER TABLE `topic`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_topic_id` (`section_id`),
  ADD KEY `idx_club_id` (`club_id`);

--
-- 表的索引 `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `idx_username` (`username`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `advert`
--
ALTER TABLE `advert`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- 使用表AUTO_INCREMENT `club`
--
ALTER TABLE `club`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- 使用表AUTO_INCREMENT `reply`
--
ALTER TABLE `reply`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- 使用表AUTO_INCREMENT `section`
--
ALTER TABLE `section`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- 使用表AUTO_INCREMENT `sign`
--
ALTER TABLE `sign`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- 使用表AUTO_INCREMENT `topic`
--
ALTER TABLE `topic`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- 使用表AUTO_INCREMENT `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(10) NOT NULL AUTO_INCREMENT COMMENT '用户ID', AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
