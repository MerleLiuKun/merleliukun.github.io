---
title: collections模块之namedtuple使用
date: 2017-07-23 13:16:21
categories: Python
tags: python
---

简介
===============
在python中tuple是一个不可变的且轻量型的集合对象，但是使用时，我们只能通过索引的方式去获取元组中的元素。不太方便，并且容易出错。而在collections模块中namedtuple对象则给出了一个更加便捷的操作方式，即给元组中的元素命名。它可以被用作类似于`struct`或其他常见`record types`，但它们是不可变的。

<!-- more -->
简单使用
===============

1.创建namedtuple
	
	form collections import namedtuple
	Point = namedtuple('Point', 'x y')

	point1 = Point(1.0, 5.0)
	point2 = Point(2.5, 1.5)	

上例即创建了一个名字为`Point`的namedtuple对象.

2.namedtuple对象的参数解析

- a.示例中的`Point`是namedtuple的名称。
- b.示例中的`x y`这个字符串中的两个用**空格**隔开的字符表示这个namedtuple中有两个元素，名为`x,y`.(避免关键字)
- c.如果在数据库中读列名作为元素名时可能会出现相同名，程序会报错，那么可以在定义namedtuple时开启自动重命名。如下：

	Point = namedtuple('Point', 'x y'， rename=True)  
	此时命名方式为`_indexnumber`,下划线+索引号。


调用方式
===============

3.1索引方式调用

	对于示例中的定义的Point1,可以采用索引方式调用获取其中的值.
	In [7]: x = point1[0]
	Out : 1.0
	In [10]: y = point1[1]
	Out : 5.0

3.2元素名方式调用

	对于示例中的定义的Point2,可以采用元素名调用获取其中的值.
	In [12]: x = point2.x
	Out : 2.5
	In [14]: y = point2.y
	Out : 1.5


总结
==============
4.1 你应该使用`namedtuple`代替那些你认为影响了你代码的易读性的`tuple`，以便让你的代码更加`pythonic`.

4.2 此外，你还可以替换那些没有功能函数、只有字段的普通不可变类。
