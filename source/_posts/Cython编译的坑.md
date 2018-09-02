---
title: Cython编译的坑
date: 2017-08-15 10:40:58
categories: Python
tags: python
---

背景
===
在项目后期，需要将产品进行发布，为了保护代码安全，最终选定将代码文件利用Cython编译成C的扩展。

有关Cython的介绍在[官网](http://docs.cython.org/en/latest/src/tutorial/cython_tutorial.html)上也有详细的说明。

这里只记录几个问题。

<!-- more -->

问题
===

不同包内模块同名问题
---

在复杂的包层次结构中，很容易出现相同的模块名，这种问题，在python中也是一个比较常见的问题，我在之前的一个博客上[Python的import](http://lkhardy.cn/2017/07/24/from-import%E5%92%8Cimport/)有所介绍。

这种问题在使用Cython编译后，这种问题暴露的更加明显。

所以如果有使用Cython编译复杂结构的模块时，一定要理清楚导入的逻辑，推荐使用`import`，尽量节制使用`from...import`

当然如果结构没那么复杂，可以考虑给模块命名不一样。


函数的参数问题
---

在使用Cython编译后，有的函数被调用时，会爆出一个无参数的TypeError：

``` python
func() takes no keyword arguments
```

在Bottle框架(一个Web框架)的[issue](https://github.com/bottlepy/bottle/issues/453)中有人也遇到这种问题。

通过这里给出的方法我们对报出Error的方法进行修改。

例如：
``` python
# 原来
def sum(a,b): pass
# 修改后
def sum(a=None, b=None): pass
```

这样可以将问题解决。

这个问题在Cython的[issue](https://github.com/cython/cython/issues/1670)中也有提到。

相关的知识在Python的文档[解析参数和生成值](https://docs.python.org/3.6/c-api/arg.html#PyArg_ParseTuple)中也有部分介绍。

