---
title: 优化你的git-commit-message
date: 2019-08-20 19:59:03
tags:
- git
- commitizen
categories:
- Git
keywords: git,commitizen
description: 优化你的git-commit-message
comments:  false
cover: https://i.loli.net/2020/01/20/aUMm2kZSbBpeVX7.png
---

简介
===

无论是写公司的项目或者是自己的项目时，总要向仓库中提交代码。每个人提交代码时写的提交信息都不一样。有随意写各种 `modify`, `fix`等简单的，还有一些比较友好，会写上自己此次提交的简介。个人觉得第二种对代码review，或者查找bug引入点时会更有帮助。

简单做个比较如下：

一、

![formated.png](https://i.loli.net/2020/01/20/765QTkLY3jlBHgF.png)

二、
![not_formated.png](https://i.loli.net/2020/01/20/VrKt2EXGcwjyDhC.png)

对比之下第一种更加清晰明了。


规范 Commit message
===================

作用
---

基本上很多团队都有自己的相关规范说明，但是目前使用的比较广泛是 [Angular 规范](https://docs.google.com/document/d/1QrDFcIiPjSLDn3EL15IJygNPiHORgU1_OOAqWjiDU5Y/edit#heading=h.greljkmo14y0), 基本样式如 上文第一张图所示。

使用依据规范的 `Commit message` 会有很多好处， 比如：

(1) 提供更多的信息，方便快速浏览。

基于规范的 `message` 可以直接信息中就包含此次提交的内容。也可以基于 `message`进行过滤

``` sh
git log v0.3 HEAD --grep feat
```

(2) 可以直接根据 `commit` 生成对应的 `Change Log`.

Commit message 格式
------------------

每次提交 都需要包含三部分：Header，Body 和 Footer。

``` js
<type>(<scope>): <subject>
// 空一行
<body>
// 空一行
<footer>
```

其中 `header`  是必须的，另外两个可以不写。

- 标题行: 必填, 描述主要修改类型和内容
- 主题内容: 描述为什么修改, 做了什么样的修改, 以及开发的思路等等
- 页脚注释: 放 Breaking Changes 或 Closed Issues

其中 标题包括三个字段：`type`（必需）、`scope`（可选）和 `subject`（必需）。

type 有以下一些常见类型：

- feat：新功能（feature）
- fix：修补bug
- docs：文档（documentation）
- style： 格式（不影响代码运行的变动）
- refactor：重构（即不是新增功能，也不是修改bug的代码变动）
- test：增加测试
- chore：构建过程或辅助工具的变动

scope 说明此次变动的范围，一般视具体的项目而定。

subject 是此次提交的简要描述。

工具 Commitizen
===============

如果我们每次手写以上的格式，必定是个痛苦的事情。所以可以使用 [Commitizen](https://github.com/commitizen/cz-cli)
这个格式化工具进行撰写.


安装
---

可以进行全局安装或者基于某项目安装。

全局安装如下：

需要在配置文件中指定 `Adapter`
``` sh
npm install -g commitizen cz-conventional-changelog

echo '{ "path": "cz-conventional-changelog" }' > ~/.czrc
```

当然可能你喜欢的格式与某个项目下要求的格式不一致。可以在某项目下进行配置。

项目内安装：
需要在项目目录下配置 `package.json`文件。
```
npm install -D commitizen cz-conventional-changelog

# 以下写入package.json.
"script": {
    ...,
    "commit": "git-cz",
},
 "config": {
    "commitizen": {
      "path": "node_modules/cz-conventional-changelog"
    }
  }
```

需要提交代码时，执行 `git cz -a`

效果如下：

![commitizen.png](https://i.loli.net/2020/01/20/aUMm2kZSbBpeVX7.png)

自定义
-----

如果需要自行配置相关的 `Adapter`, 可以使用 [cz-customizable](https://github.com/leonardoanalista/cz-customizable) 进行自定义。

```sh
npm i -g cz-customizable  # 全局
npm i -D cz-customizable  # 项目级
```

修改对应的配置：

``` sh
# 全局 .czrc
{ "path": "cz-customizable" }

# 项目级 (package.json)
"config": {
    "commitizen": {
        "path": "node_modules/cz-customizable"
    }
}
```

推荐一下大佬的配置 [ leohxj/.cz-config.js](https://gist.github.com/leohxj/7bc928f60bfa46a3856ddf7c0f91ab98)


参考
===

- [Commit message 和 Change log 编写指南-阮一峰](http://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html)
- [优雅的提交你的 Git Commit Message-阿里南京技术专刊](https://zhuanlan.zhihu.com/p/34223150)
