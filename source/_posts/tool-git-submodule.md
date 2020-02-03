---
title: Git submodule 子模块管理
date: 2019-08-01 21:59:04
categories:
- Git
tags:
- git
- submodule
keywords: git,submodule
description: Git submodule 子模块管理
cover: https://i.loli.net/2020/02/03/HypBcsILXoMmNxz.png
---

在使用某些大型项目时，会发现项目会引用了其他的一些项目，而引用的这些项目也会进行一些更新维护的操作。那么如何对这些子项目进行管理呢？ 当然你可以将子项目的更新进行手动调整，进而提交到主项目中。但是这种操作并不友好，并且会污染主项目的提交历史。

`Git` 通过子模块 [submodule](https://github.blog/2016-02-01-working-with-submodules/) 来解决这样的问题。子模块允许你将一个 `Git` 仓库作为另一个 `Git` 仓库的子目录。 它能让你将另一个仓库克隆到自己的项目中，同时还保持提交的独立。


在使用 `Hexo` 搭建静态博客时，我们会通常不会选用内置的主题，而是选择更好看的第三方主题。那么就是上边我们说的场景。我们要在博客的主仓库中对主题的仓库进行统一处理。我们以此为例，简单介绍一下对子模块的使用。

开始使用子模块
============

假如我们使用第三方主题 [hexo-theme-next](https://github.com/iissnan/hexo-theme-next)。通过命令 `git submodule add` 来添加新的子模块。

``` bash
git submodule add https://github.com/iissnan/hexo-theme-next
```

此时会把主题项目 `hexo-theme-next` 克隆到当前目录下的同名目录中。如果你想要将其放置到其他目录，可以在命令后边加上制定的目录，例如：

``` bash
git submodule add https://github.com/iissnan/hexo-theme-next themes/hexo-theme-next
```

此时你可以使用 `git status` 命令查看当前仓库的状态

``` bash
$ git status
On branch master
Your branch is up-to-date with 'origin/master'.

Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)
        新文件：   .gitmodules
        新文件：   themes/hexo-theme-next

```

关键注意点是文件 `.gitmodules`，该配置文件存储了项目和本地目录之间的映射关系。
其中 `path` 指定本地的相对目录，`url` 指定子项目的仓库地址。

该文件需要进行版本控制，用于其他人也可以知道子模块的位置。


克隆含有子模块的项目
=================

如果需要完整克隆带有子模块的项目，有两种方式：

1. 正常克隆主项目，然后更新子模块
2. 使用参数 `--recursive` 自动初始化并更新所有的子模块

先克隆后更新
----------

先克隆主项目

``` bash
$ git clone git@github.com:MerleLiuKun/merleliukun.github.io.git
```

切换到项目目录下，初始化子模块，注意初始化只需要执行一次

``` bash
$ git submodule init
```

更新子模块

``` bash
$ git submodule update
```

递归克隆整个项目
--------------

采用递归参数 `--recursive`  克隆项目

``` bash
$ git clone --recursive git@github.com:MerleLiuKun/merleliukun.github.io.git
```

其他操作
========

查看子模块
--------

切换到主项目目录下

``` bash
$ git submodule 
620b1e829eb8b6fd72426f3009866b79d8ee2e7b themes/hexo-theme-next (v5.1.1-693-g620b1e8)
```

删除子模块
---------

切换到主项目目录下

``` bash
$ git submodule deinit themes/hexo-theme-next
$ git rm themes/hexo-theme-next
```

参考文献
=======

- [Git-Tools-Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
- [Working with submodules](https://github.blog/2016-02-01-working-with-submodules/)
