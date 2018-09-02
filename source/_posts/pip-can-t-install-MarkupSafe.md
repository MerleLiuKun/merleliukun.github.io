---
title: pip can not install MarkupSafe
date: 2017-08-07 09:06:16
categories: Python
tags: python
---

背景
===
今天早上试用[pyecharts](https://github.com/chenjiandongx/pyecharts)时（环境：Python3.6.1），使用pip安装.在安装时报出错误。此错误应该是针对于（`MarkupSafe`）模块的。
如下：
![error1.png](http://upload-images.jianshu.io/upload_images/1747527-6e1bf19cf67cc87f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

<!-- more -->

解决问题
===
1、通过traceback可以看到应该是pip命令将控制台的字符串进行编码转换时出现了错误。因为我这是在windows下进行的，所以`console`上使用的是`gbk`的编码，但是pip模块却使用`utf-8`进行解码，所以产生了错误。
找到对应的出错位置，我们修改一下对应的代码。
找到`\lib\site-packages\pip\compat\__init__.py`文件
定位到第75行：
![code.png](http://upload-images.jianshu.io/upload_images/1747527-8a0766195459709b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

我们将原来的`utf_8`修改为`gbk`.

执行 `pip freeze`命令，如果存在安装包（MarkupSafe）， 先进行卸载。

重新安装。 发现没有问题。

同样环境在Linux下却不会出现问题，因为Linux的console默认`utf-8`编码。
如图(`Konsole`)：

![konsole_encoding.png](http://upload-images.jianshu.io/upload_images/1747527-810e236b53419364.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


