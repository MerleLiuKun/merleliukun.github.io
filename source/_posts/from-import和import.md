---
title: from-import和import
date: 2017-07-24 22:42:06
categories: Python
tags: python
---

简介：
==

在使用Python编写项目时，我们经常使用`import xx`或者`from xx import a`去导入其他模块或者其他模块中的一些对象和方法，那么这两个语句有什么不一样的呢。在此处，做一下总结，让自己对它们的原理进行一些了解。
<!-- more -->
方法：
==

Python提供了三种方法引入外部模块，`import`语句、`from...import...`和`__import__`函数。我们最为常用的是前两者。对于第三种方式，它与`import`语句类似，只是前者显式的将模块的名称作为字符串传递并赋值给命名空间的变量。

注意事项：
--

- 尽量优先使用`import`语句，如`import a.B`，可以访问B
- 有节制的使用`from a import B`形式，但是这样也可以直接访问B
- 避免使用`from a import *`形式，这样会**污染命名空间**，并且导入了哪些模块也不清晰。

import的原理
==

Python的import机制，在Python初始化运行环境时候会预先加载一批内建模块到内存中，这些模块相关的信息存放在了`sys.modules`中，用户导入`sys`模块后使用`sys.modules.items()`可以显示所有预加载模块的相关信息。

当加载一个模块时，Python解释器做了以下一些事情：

1. 在`sys.modules`中进行搜索，如果该模块已经存在，就将该模块导入到当前局部命名空间。加载就结束了。
2. 如果在`sys.modules`中找不到该模块的名称，则为需要导入的模块创建一个字典对象，并将该对象信息插入到`sys.modules`中。
3. 加载前确认是否需要对模块对应的文件进行编译，如果需要编译就要进行编译。
4. 执行动态加载，在当前模块中的命名空间中执行编译后的字节码文件，并将其中所有的对象放入到模块对应的字典中。



无节制使用from...import...带来的问题
==

命名空间冲突
--

例子：有如下三个文件

![图1](http://i.imgur.com/6V3fNoA.png)

在模块a和模块b中都定义了`add()`函数。那么我们在test文件中使用`from...import...`的形式导入`add`时，最终起作用的是哪一个呢？

	# filename a.py
	def add():
		print("add in module A")

	# filename b.py
	def add():
		print("add in module B")
	
	# filename test.py
	from a import add
	from b import add

	if __name__ == '__main__':
		add()

运行test.py之后，我们得到输出：
	
	"add in module B"

也就是说在这里起作用的是最近导入的add(),它完全覆盖了当前命名空间中之前导入的模块a中的add().所以在大型的项目中，我们所包含的包和模块数目非常多，因此使用`from...import...`语句将会大大增加了命名空间冲突的概率，很大可能会导致出现无法预料的错误和问题。所有有必要有节制的使用`from...import...`语句。

>当然在以下的一些情况中可以考虑使用`from...import...`语句
>
1. 当只需要导入部分属性或者方法时。
2. 模块中的某些属性和方法使用频率很高导致使用`a.B`这种形式进行访问过于烦琐时。
3. 某模块的文档明确说明需要使用`from...import`形式，能后更为简单
和便利时。如使用`from io.drivers import zip`要比使用`import iodrivers.zip`更加方便。

循环嵌套导入问题
--
例子：

	# filename c1.py
	from c2 import g
	def x():
		pass

	# filename c2.py
	from c1 import x
	def g():
		pass

像上边的两个文件，无论运行哪一个，都会报出`ImportError`的错误。解析如下：



1. 在执行`c1.py`的加载过程的时候需要创建新的模块对象c1然后执行c1.py所对应的字节码，此时遇到语句`from c2 import g`,而此时c2在sys.modules中并不存在。然后就会创建与c2对应的模块对象并执行c2.py，
2. 而在执行c2.py时候，又遇到`from c1 import x`语句，此时的c1对象虽然已经存在，但是初始化的过程并未完成，所以不存在x对象，所以c2也无法初始化完成。
3. 再次执行c1.py时，就会报出`ImportError: cannot import name g`异常。

而使用import可以解决这个问题。
修改文件如下：

	# filename c1.py
	import c2
	def x():
		pass

	# filename c2.py
	import c1
	def g():
		pass

此时就可以运行这两个文件了。

