---
title: python函数之format
date: 2017-07-28 21:07:32
categories: Python
tags: python
---

python format 函数总结
====
文章基于Python2.7.12进行讲述：

&#160;&#160;&#160;&#160;在python中格式化字符串进行输出时，通常会用到format函数。

&#160;&#160;&#160;&#160;介绍一下简单用法：

&#160;&#160;&#160;&#160;1.将字符串替换

<!-- more -->

	In [1]: print '{0} {1} {2}'.format('a', 'b', 'c')
	a b c

&#160;&#160;&#160;&#160;2.按照参数格式化

	In [2]: print '{name} {age}'.format(age=21, name='lkhardy')
	lkhardy 21

&#160;&#160;&#160;&#160;3.限制字符串内的信息范围

	In [3]: print '{array[5]}'.format(array=range(10))
	5

	In [4]: print '{array[12]}'.format(array=range(10))
	-------------------------------------IndexError
    Traceback (most recent call last)
	<ipython-input-13-e9cd5827deae> in <module>()---->
	 1 print '{array[12]}'.format(array=range(10))

	IndexError: list index out of range

&#160;&#160;&#160;&#160;4.直接调用系统函数

	In [14]: print '{attr.__class__}'.format(attr=0)
	<type 'int'>

	In [15]: print '{attr.__class__}'.format(attr="d")
	<type 'str'>

&#160;&#160;&#160;&#160;5.转义

	In [18]: print '{name!r}'.format(name=u'汉字')
	u'\u6c49\u5b57'

	In [19]: print '{name!r}'.format(name=u'lkhardy')
	u'lkhardy'

	In [20]: print '{name!r}'.format(name=u'1234')
	u'1234'

&#160;&#160;&#160;&#160;6.识别格式化

	In [24]: print '{digit:*^ 10.5f}'.format(digit=1.0/3)
	* 0.33333*

	In [25]: print '{digit:*^ 10.5f}'.format(digit=10.0/3)
	* 3.33333*

未完待续。。。。。。

